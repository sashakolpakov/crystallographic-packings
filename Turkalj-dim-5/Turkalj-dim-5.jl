using Pkg
# First, activate the project: this should load all dependencies, etc
Pkg.activate(".")
# `instantiate` actually ensures that the dependency are exactly at the same state than on my computer
Pkg.instantiate()

# Load the module
using VinbergsAlgorithmNF

# Load Hecke, which deals with everything number theoretic
using Hecke

# And LinearAlgebra
using LinearAlgebra

# And CoxeterDiagrams, which contains the algo to check co{compactness,finiteness}
using CoxeterDiagrams

# **Important**: if you want the code to run fast enough, always call `toggle(false)` first.
# I peppered the code with asserts at some performance critical places, and calling `toggle(false)` disables those asserts.
using ToggleableAsserts
toggle(false)

# This is just a shortcut to not have to write `VinbergsAlgorithmNF` in full everytime
VA = VinbergsAlgorithmNF

# This is "orthogonal sum"
⊕ = VA.Lat.:(⊕)

# These are the usual lattices (defined in `src/some_lattices.jl`)
H = VA.Lat.U()
block_diag = VA.Lat.block_diag

# Define the field
ℚ, a = Hecke.rationals_as_number_field()

# Quadratic forms from Turkalj in dimension 5 (up to rational isometry)

Turkalj_dim_5 = [
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1],
    [0, -1, 0, 0, 1, 0, -1, -2, 0, 0, 1, -1, 0, 0, 2, -1, 1, -1, 0, 0, -1, 2, -1, 1, 1, 1, 1, -1, 2, 0, 0, -1, -1, 1, 0, 2],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 1, 2],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 3],
    [0, -1, 0, 0, -1, -2, -1, -2, -1, 1, 0, 0, 0, -1, 2, 0, 0, 0, 0, 1, 0, 2, 1, 1, -1, 0, 0, 1, 10, 2, -2, 0, 0, 1, 2, 12],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -2, 1, 0, 0, 0, 0, 1, 2],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -2],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 6],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -6],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 7],
    [0, -1, 0, 0, 0, -2, -1, 0, 0, 0, 1, -2, 0, 0, 2, -1, 1, 1, 0, 0, -1, 4, 1, 1, 0, 1, 1, 1, 4, 1, -2, -2, 1, 1, 1, -4],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 15],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -2, 1, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 3],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -2, 1, 0, 0, 0, 0, 1, 7],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 10, 5, 0, 0, 0, 0, 5, 10],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, -6],
    [0, -1, -1, -3, 2, -6, -1, 0, 0, 1, -1, -3, -1, 0, 2, -1, 0, 0, -3, 1, -1, 12, -3, -4, 2, -1, 0, -3, 12, -4, -6, -3, 0, -4, -4, -20],
    [0, 0, 0, 0, 0, 1, 0, 2, 0, 0, -1, -1, 0, 0, 2, 1, 0, 1, 0, 0, 1, 2, 0, 0, 0, -1, 0, 0, 4, 1, 1, -1, 1, 0, 1, -6],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0, 14],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, -10],
    [2, 1, -1, 1, 0, 0, 1, 2, -1, 0, 0, 0, -1, -1, 2, -1, 0, 0, 1, 0, -1, 2, 0, 0, 0, 0, 0, 0, 2, -1, 0, 0, 0, 0, -1, -10],
    [2, 0, 0, 0, 0, 1, 0, 2, 1, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 0, 2, -1, 1, 0, 0, 1, -1, -6]
]

function is_good(das)
    m, n = size(das.D, 1), size(das.D, 2)
    @assert m==n "!!! Something wrong with the diagram matrix !!! \n"
    for i in 1:n
        face_neighbours = das.D[i,:]
        if all(x->(x<=2), face_neighbours)
            return true
        end
    end
    return false
end

function data_and_diagrams_dim_5()
    ind = 0
    for L in Turkalj_dim_5
        ind = ind + 1
        print("Starting Vinberg algorithm for no. ", ind, "\n")
        vd = VA.VinbergData(ℚ, reshape(L, 6, 6))
        (status, (roots, dict, das)) = VA.next_n_roots!(vd, n=128)
        print("Number of roots: ", length(roots), "\n")
        print("All roots found: \n")
        print(roots, "\n")
        print("\n")
        @assert status==true "!!! Error at no. "*string(ind)*" !!!\n"
        if is_good(das)
            print("Has an isolated root (good) \n")
            CoxeterDiagrams.save_png("/Users/sasha/VinbergsAlgorithmNF/scratchpad/Turkalj-dim-5/Good/tur5no"*string(ind)*".png", das)
        else
            print("Does *not* have an isolated root (bad) \n")
            CoxeterDiagrams.save_png("/Users/sasha/VinbergsAlgorithmNF/scratchpad/Turkalj-dim-5/Bad/tur5no"*string(ind)*".png", das)
        end
    end
end

# Drawing the diagrams and saving them each in a separate PNG file

data_and_diagrams_dim_5()

# b as in "bad"

print("\n")
print("Commensurable lattices for bad lattices ... \n")
print("\n")

for b in [1, 2, 3, 5, 11]
    L = Turkalj_dim_5[b]
    print("Starting Vinberg algorithm for no. ", b, " commensurable \n")
    c = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 1 0 0 0; 0 0 0 1 0 0; 0 0 0 0 1 0; 0 0 0 0 0 2]
    q = c*reshape(L, 6, 6)*transpose(c)
    vd = VA.VinbergData(ℚ, q)
    (status, (roots, dict, das)) = VA.next_n_roots!(vd, n=128)
    print("Number of roots: ", length(roots), "\n")
    print("All roots found: \n")
    print(roots, "\n")
    print("\n")
    @assert status==true "!!! Error at no. "*string(b)*" !!! \n"
    @assert is_good(das) "!!! Is not good (yet) !!! \n"
    CoxeterDiagrams.save_png("/Users/sasha/VinbergsAlgorithmNF/scratchpad/Turkalj-dim-5/Bad/tur5no"*string(b)*"comm.png", das)
end
