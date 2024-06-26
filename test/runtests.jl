using Test
using Albacea

# 1
"""
    A

Some mock singleton struct.
"""
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
"""
    B <: A

Some mock struct that inherits from `A`.
"""
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
"""
    C <: B

Some mock struct that inherits from `B`.
"""
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

# 3
"""
    D <: C

Some mock struct that inherits from `C`.
"""
@testate struct D <: C end

@test hasproperty(@__MODULE__, :D)
@test isabstracttype(D)
@test hasproperty(@__MODULE__, :D_Concrete)
@test isstructtype(D_Concrete)
@test D_Concrete <: C
@test D <: B

@test concreteof(D) == D_Concrete
@test abstractof(D_Concrete) == D

@test D(C(B(A(), 1), true)) == D_Concrete(C(B(A(), 1), true))
@test D(C(C(B(A(), 1), true))) == D(C(B(A(), 1), true))

@test B(D(C(B(A(), 1), true))) == B(A(), 1)
@test A(D(C(B(A(), 1), true))) === A()
