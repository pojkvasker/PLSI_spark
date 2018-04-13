# 100 users, 60 films, 5 profiles
M = matrix(NA, nrow=3000, ncol=2)
M[,1] = round(runif(3000, 1, 100))
M[,2] = round(runif(3000, 1, 60))
M = unique(M)

P_yz = matrix(1/60, nrow=60, ncol=5)
P_zu = matrix(1/5, nrow=5, ncol=100)

P_zuy = array(NA, c(100,60,5))


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
    for(i in 1:nrow(M)){
        den = den + P_zuy[M[i,1],M[i,2],z]
        if(M[i,2] == y){
          num = num + P_zuy[M[i,1],M[i,2],z]
        }
    }
    P_yz[y,z] = num/den
  }
}


for(u in 1:ncol(P_zu)){
  for(z in 1:nrow(P_zu)){
    num = 0
    den = 0
    for(i in 1:nrow(M)){
      if(M[i,1] == u){
        num = num + P_zuy[M[i,1],M[i,2],z]
        for(z in 1:nrow(P_zu)){
          den = den + P_zuy[M[i,1],M[i,2],z]
        }
      }
    }
    P_zu[z,u] = num/den
  }
}



