library(readr)
ratings <- read_csv("~/Università/ERASMUS/Dauphine/Corsi/Big Data/FinalProject/ml-latest-small/ratings.csv")

# Test con 1000 righe della matrice di dati originale

A = ratings[ratings[,3]>2.5,]
A = A[,1:2]

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
test = B[1:3000,]

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

length(unique(test[,1])) #users 559
length(unique(test[,2])) #movies 1668

P_yz = matrix(1/1668, nrow=1668, ncol=10)
P_zu = matrix(0, nrow=10, ncol=559)

# P_yz[1:200,1]=0.5/200
# P_yz[201:300,1]=0.5/100
# P_yz[1:100,2]=0.5/100
# P_yz[301:500,2]=0.5/200
# P_yz[101:400,3]=1/300
# P_yz[401:800,4]=1/400
# P_yz[501:700,5]=0.5/200
# P_yz[801:900,5]=0.5/100
# P_yz[701:1100,6]=1/400
# P_yz[901:1400,7]=1/500
# P_yz[1101:1300,8]=1/200
# P_yz[1301:1668,9]=1/(length(1301:1668))
# P_yz[1401:1668,10]=1/(length(1401:1668))


for(i in 1:ncol(P_zu)){
  c = i/560
  P_zu[,i]=dbinom(seq(1,10),10,prob=c)
}



# P_yz = matrix(1/length(unique(test[,2])), nrow=length(unique(test[,2])), ncol=20)
# P_zu = matrix(1/20, nrow=20, ncol=length(unique(test[,1])))

P_zuy = array(NA, c(559,1668,10))

# EM algorithm

mean=c()
k=1
while(k != 10){
  
  # E-step
  
  P_yu = P_yz%*%P_zu
  
  total = 0
  for(i in 1:nrow(test)){
    total = total + P_yu[test[i,2], test[i,1]]
  }
  mean[k] = total/nrow(test)
  
  k = k+1
  
  for(z in 1:nrow(P_zu)){
    for(y in 1:nrow(P_yz)){
      for(u in 1:ncol(P_zu)){
        P_zuy[u,y,z] = (P_yz[y,z]*P_zu[z,u])/P_yu[y,u]
      }
    }
  }
  
  
  # M-step
  
  # # P(y|z)
  # for(z in 1:nrow(P_zu)){
  #   for(y in 1:nrow(P_yz)){
  #     num = 0
  #     den = 0
  #     for(i in 1:nrow(test)){
  #       den = den + P_zuy[test[i,1],test[i,2],z]
  #       if(test[i,2] == y){
  #         num = num + P_zuy[test[i,1],test[i,2],z]
  #       }
  #     }
  #     P_yz[y,z] = num/den
  #   }
  # }
  
  # Alternativa più veloce?
  
  for (z in 1:ncol(P_yz)){
    den = 0
    for(i in 1:nrow(test)){
      den = den + P_zuy[test[i,1], test[i,2], z]}
    for(y in 1:nrow(P_yz)){
      num = 0
      for(i in 1:nrow(test)){
        if(test[i,2] == y){
          num = num + P_zuy[test[i, 1],test[i, 2], z]
        }
      }
      P_yz[y,z] = num/den
    }
  }
  
  
  # P(z|u)
  
  # Vecchio e non funzionante, quindi rottamato
  # for(u in 1:ncol(P_zu)){
  #   for(z in 1:nrow(P_zu)){
  #     num = 0
  #     den = 0
  #     for(i in 1:nrow(test)){
  #       if(test[i,1] == u){
  #         num = num + P_zuy[test[i,1],test[i,2],z]
  #         for(z in 1:nrow(P_zu)){
  #           den = den + P_zuy[test[i,1],test[i,2],z]
  #         }
  #       }
  #     }
  #     P_zu[z,u] = num/den
  #   }
  # }
  
  
  for(u in 1:ncol(P_zu)){
    for(z in 1:nrow(P_zu)){
      num = 0
      for(i in 1:nrow(test)){
        if(test[i,1] == u){
          num = num + P_zuy[test[i,1],test[i,2],z]
        }
      }
      P_zu[z,u] = num
    }
  }
  for(u in 1:ncol(P_zu)){
    P_zu[,u] = P_zu[,u]/sum(P_zu[,u])
  }
}

