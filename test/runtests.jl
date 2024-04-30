using Test
using Albacea

# 1
@testate struct A end

@test hasproperty(@__MODULE__, :A)
@test isabstracttype(A)
@test hasproperty(@__MODULE__, :A_Concrete)
@test isstructtype(A_Concrete)
@test A_Concrete <: A

@test concreteof(A) == A_Concrete
@test abstractof(A_Concrete) == A

@test A() === A_Concrete()
@test A(A()) === A()

# 2
@testate struct B <: A
    x::Int
end

@test hasproperty(@__MODULE__, :B)
@test isabstracttype(B)
@test hasproperty(@__MODULE__, :B_Concrete)
@test isstructtype(B_Concrete)
@test B_Concrete <: B
@test B <: A

@test concreteof(B) == B_Concrete
@test abstractof(B_Concrete) == B

@test B(A(), 1) == B_Concrete(A(), 1)
@test B(B(A(), 1)) == B(A(), 1)

@test A(B(A(), 1)) === A()

# 3
@testate struct C <: B
    y::Bool
end

@test hasproperty(@__MODULE__, :C)
@test isabstracttype(C)
@test hasproperty(@__MODULE__, :C_Concrete)
@test isstructtype(C_Concrete)
@test C_Concrete <: C
@test C <: B

@test concreteof(C) == C_Concrete
@test abstractof(C_Concrete) == C

@test C(B(A(), 1), true) == C_Concrete(B(A(), 1), true)
@test C(C(B(A(), 1), true)) == C(B(A(), 1), true)

@test B(C(B(A(), 1), true)) == B(A(), 1)
@test A(C(B(A(), 1), true)) === A()
