# Crystallographic packings
(and associated reflective Lorentzian lattices)

Proof of Theorem B: 
1) SageMath code in Borcherds-polyhedron-dim-21-faces looking for "good" lower-dimensional faces of the Borcherds 21-dimensional polyhedron ("good" faces give rise to reflective lattices with isolated roots).

Proof of Theorem C: 
1) SageMath code in Lattices-3-4-5 classifying the Scharlau-Walhorn and Turkalj lattices up to rational isometries; 
2) Julia code in Scharlau-Walhorn-dim-{3|4} and Turkalj-dim-5 looking for lattices with isolated roots among the ones above.

SageMath code in Borcherds-polyhedron-dim-17-faces checks that:
1) the 17-dimensional Borcherds polytope does not have an orthogonal or "good" facet (i.e. (codimension 1 face);
2) the 17-dimensional Borcherds polytope does not have any Coxeter facets. 

Note that all Julia code uses Bottinelli's implementation https://github.com/bottine/VinbergsAlgorithmNF.git of the Vinberg algorithm. 