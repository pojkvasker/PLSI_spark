# PLSI_spark

Simple recommender system based on latent classes - Probabilistic Semantic Latent
Indexing (PLSI)
Let us consider a dyadic dataset, composed of N users U = {u1, ... uN} and M items I = {i1, ..., iM}.
For each (user, item) pair, you know if a user interacted with or liked an item. In this project, you
will implement a basic recommendation algorithm based on Hoffman (1999) work, to recommend
items to users.
Hoffman (1999) describes a simple probabilistic algorithm based on latent classes. Latent classes
are unobserved classes, clustering both users and items. The authors assume a multinomial
distribution of users given latent classes, and of items given classes. Users and item can then
belong to several latent classes. Latent classes are expected to gather similar items and users, for
example, there can be a class gathering sci-fi fans and Star Trek movies.
Parameter estimation is done using the EM algorithm, which is a standard procedure when working
with latent parameters.
This algorithm was one of the building bricks of Google News recommender system. Das (2007)
describe Google’s MapReduce implementation of the basic PLSI algorithm (see section 4.2).
You are asked to implement in Spark the PLS algorithm, based on Das (2007) MapReduce
formulation, and to apply it on the well known Movielens dataset.
Note that the Movielens dataset contains ratings ranging from 1 to 5. You can reduce this
information to seen/not seen in order to use the basic version of PLSI. If you are very motivated,
you can try to integrate preference values to PLSI, as described in Hoffman (1999). You can also
compare your results to Spark LDA implementation and discuss the use of LDA versus PLSI.
________________
[1] Hofmann, Thomas, and Jan Puzicha. "Latent class models for collaborative filtering." IJCAI. Vol.
99. No. 1999. 1999. – http://people.eecs.berkeley.edu/~russell/classes/cs294/f05/papers/
hofmann+puzicha-1999.pdf
[2] Das, A. S., Datar, M., Garg, A., & Rajaram, S. (2007, May). Google news personalization:
scalable online collaborative filtering. In Proceedings of the 16th international conference on World
Wide Web (pp. 271-280). ACM. –
https://pdfs.semanticscholar.org/fb42/07376177f18a6cf58b53ecd231fb3395ca33.pdf
