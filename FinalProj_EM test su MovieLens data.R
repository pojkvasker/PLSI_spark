library(readr)
ratings <- read_csv("~/Università/ERASMUS/Dauphine/Corsi/Big Data/FinalProject/ml-latest-small/ratings.csv")

# Test con 1000 righe della matrice di dati originale

A = ratings[,1:3]

A = A[A[,3]>2.5,]
A = A[,1:2]

P_yz = matrix(1/60, nrow=671, ncol=20)
P_zu = matrix(1/5, nrow=20, ncol=9066)

B = A[order(A$movieId),]

B["movieId_2"] = NA

i = 1
B[1,3]=1
for(j in 2:nrow(B)){
  if(B[j,2]==B[j-1,2]){
    B[j,3] = i
  }
  else{
    i = i + 1
    B[j,3] = i
  }
}

B = B[sample(1:nrow(B)),]
test = B[1:1000,]

test = test[order(test$userId),]

i = 1
test[1,2]=1
for(j in 2:nrow(test)){
  if(test[j,1]==test[j-1,1]){
    test[j,2] = i
  }
  else{
    i = i + 1
    test[j,2] = i
  }
}

test = test[order(test$movieId_2),]

i = 1
test[1,1]=1
for(j in 2:nrow(test)){
  if(test[j,3]==test[j-1,3]){
    test[j,1] = i
  }
  else{
    i = i + 1
    test[j,1] = i
  }
}

library(plyr)
test = rename(test, c("userId"="movies", "movieId"="users"))
test = test[,1:2]
test = test[,c(2,1)]
test = cbind(test[,1],as.numeric(test[,2]))

length(unique(test[,1]))
length(unique(test[,2]))

P_yz = matrix(1/length(unique(test[,2])), nrow=length(unique(test[,2])), ncol=20)
P_zu = matrix(1/20, nrow=20, ncol=length(unique(test[,1])))

P_zuy = array(NA, c(658,3333,20))


# E-step

P_yu = P_yz%*%P_zu

for(z in 1:nrow(P_zu)){
  for(y in 1:nrow(P_yz)){
    for(u in 1:ncol(P_zu)){
      P_zuy[u,y,z] = (P_yz[y,z]*P_zu[z,u])/P_yu[y,u]
    }
  }
}


# M-step
for(z in 1:nrow(P_zu)){
  for(y in 1:nrow(P_yz)){
    num = 0
    den = 0
    for(i in 1:nrow(test)){
      den = den + P_zuy[test[i,1],test[i,2],z]
      if(test[i,2] == y){
        num = num + P_zuy[test[i,1],test[i,2],z]
      }
    }
    P_yz[y,z] = num/den
  }
}

# Alternativa più veloce?

# for (z in 1:ncol(P_yz)){
#   den = 0
#   for(i in 1:nrow(test)){
#     den = den + P_zuy[test[i,1], test[i,2], z]}
#   for(y in 1:nrow(P_yz)){
#     num = 0
#     for(i in 1:nrow(test)){
#       if(test[i,2] == y){
#         num = num + P_zuy[test[i, 1],test[i, 2], z]
#       }
#     }
#     P_yz[y,z] = num/den
#   }
# }


for(u in 1:ncol(P_zu)){
  for(z in 1:nrow(P_zu)){
    num = 0
    den = 0
    for(i in 1:nrow(test)){
      if(test[i,1] == u){
        num = num + P_zuy[test[i,1],test[i,2],z]
        for(z in 1:nrow(P_zu)){
          den = den + P_zuy[test[i,1],test[i,2],z]
        }
      }
    }
    P_zu[z,u] = num/den
  }
}

