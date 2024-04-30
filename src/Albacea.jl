module Albacea

using Expronicon

export @testate, @will

function abstractof end
function concreteof end

"""
    @testate struct A end
    @testate struct B <: A end

Declare a struct that inherits from another struct.
The inheritee will contain a field `super` that will hold the parent struct (i.e inheritance through composition).
"""
macro testate(def)
    jlstruct = JLStruct(def)

    AbstractClass = jlstruct.name
    AbstractSuperClass = jlstruct.supertype
    ConcreteClass = Symbol(jlstruct.name, :_Concrete)
    ConcreteSuperClass = isnothing(AbstractSuperClass) ? nothing : Symbol(jlstruct.supertype, :_Concrete)

    quote
        $(
            if isnothing(jlstruct.supertype)
                :(abstract type $AbstractClass end)
            else
                :(abstract type $AbstractClass <: $(esc(AbstractSuperClass)) end)
            end
        )

        struct $ConcreteClass <: $(esc(AbstractClass))
            $(if !isnothing(ConcreteSuperClass)
                esc.([:(super::$ConcreteSuperClass), codegen_ast.(jlstruct.fields)...])
            else
                esc.(codegen_ast.(jlstruct.fields))
            end...)
        end

        # constructor alias
        function $(esc(AbstractClass))($(esc(:args))...; $(esc(:kwargs))...)
            return $(esc(ConcreteClass))($(esc(:args))...; $(esc(:kwargs))...)
        end

        # rename concrete class
        # $(Base).typename(::Type{$(esc(ConcreteClass))}) = $(Base).typename($(esc(AbstractClass)))

        # superclass extraction
        $(esc(AbstractClass))($(esc(:x))::$(esc(AbstractClass))) = $(esc(AbstractClass))($(esc(:x)).super)
        $(esc(AbstractClass))($(esc(:x))::$(esc(ConcreteClass))) = $(esc(:x))

        # concreteof/abstractof methods
        $(Albacea).concreteof(::Type{$(esc(AbstractClass))}) = $(esc(ConcreteClass))
        $(Albacea).abstractof(::Type{$(esc(ConcreteClass))}) = $(esc(AbstractClass))
    end
end

end
