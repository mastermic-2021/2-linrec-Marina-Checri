ascii2str(v)=Strchr(v);
u27 = ffgen(('x^3-'x+1)*Mod(1,3),'u);
codf27(s) = [if(x==32,0,u27^(x-97))|x<-Vec(Vecsmall(s)),x==32||x>=97&&x<=122];

/*
 * D'après la fonction ci-dessus, x est codé par u27^k où k=x-97.
 * Donc un élément de la forme u27^k se décode en faisant k+97=x.
*/

/*
\\Essai infructueux reprenant la syntaxe pour l'encodage ...
\\A comprendre !
findPow(x)={
   k=-1;
   for(i=0,25, if(x==u27^i,k=i));
   k;
}
decodf27(s) = [ if(findPow(x)==-1,32,findPow(x)) | x<-Vec(s), x==0];
*/


decode(s)={
  v= vector(#s);
  vector(#s,i, for(k=0,25, if(s[i]==0, v[i]=32,if(s[i]==u27^k, v[i]=k+97)) ) );
  v;
}
decodf27(s)=ascii2str(decode(s));



/* ****************************************************************************** */
/* *********************************** Idées : ********************************** */
/* ****************************************************************************** */

/*
 * Au début, je croyais qu'il fallait utiliser une fonction calculant
   les n premiers termes d'un LFSR.
 * Pour cela, j'ai repris l'algorithme vu en cours (ci-dessous).
 * Mais il s'est avéré qu'il n'était pas assez efficace.
*/

suite_rec_lineaire(u_0,annul,nb) = {
  if(type(annul)=="t_POL",annul=Vecrev(annul));
  d = #annul - 1;
  if(type(u_0)=="t_POL",u_0=Vecrev(u,d));
  v = Vec(u_0,nb);
  for(k=d,nb, v[k] = -sum(i=1,d,v[k-d+i]*annul[i]));
  v;
}


/*
 * Après discussions et réflexions, j'ai compris qu'il nous faudrait plutôt utiliser
   une matrice de transition pour obtenir les termes de la suite
   (matrice définissant la relation de récurrence).
 * Il suffirait alors d'utiliser un algorithme d'exponentiation rapide,
   permettant de calculer les puissances de cette dernière,
   et ainsi, les différents termes de la suite !
 * Ci-dessous, un algorithme d'exponentiation rapide pour une matrice.
*/

ExpMat(M,e) = {
	if(e == 0, return (matid(matsize(M)[1])),
	    if(e == 1, return (M),
	        if(e%2 == 0,return (ExpMat(M^2,e/2)), return (M*ExpMat(M^2,(e-1)/2)) )) );
}


/*
 * Après discussions (notamment avec Daphné), je comprends qu'on peut appliquer
   les n itérations à l'aide de la décomposition en facteurs premiers de n
   (ce qui, en fait, peut se faire simplement à l'aide de la fonction factor(n)  !!).
 * C'est ce que fait la fonction ci-dessous, qui élève M à la puissance n :
*/

IterN(M,n)={
	f=factor(n);
	for(i=1,matsize(f)[1], M=ExpMat(M,f[i,1]^f[i,2]));
	M;
}




/* ****************************************************************************** */
/* **************************** Posons nos données : **************************** */
/* ****************************************************************************** */


text  = read("input.txt")[1];
text2 = read("input.txt")[2];
n     = read("input.txt")[3];

\\n = 929583887302112
\\p = x^40+x+u
\\sur F27=F3[u]/u^3-u+1


/* ****************************************************************************** */
/* *************************** Application de cela : **************************** */
/* ****************************************************************************** */

text  = codf27(text);
text2 = codf27(text2);


/* ****************************************************************************** */

/*
 * Le principe est le suivant :
 * On va construire la matrice définissant la relation de récurrence, puis l'inverser
   (car on est du côté d'Adèle -> on doit décoder).
 * Ensuite, il suffira d'élever cette matrice à la puissance n
   (ce que l'on fait à l'aide de la décompostion en facteurs premiers de n - factor(n),
   et d'une fonction d'exponentiation rapide).
 * Enfin, on multiplie à gauche le vecteur par notre matrice.
   (Nota Bene : puisqu'on doit faire la multiplication M*v,
   on n'oublie pas de changer v en vecteur colonne.)
 * Il ne reste qu'à décoder en lettres !
*/


\\ Création de la matrice définissant la relation de récurrence.
m = matrix(40,40,i,j,if(j==i+1,1,0));
m[40,1] = -u27;
m[40,2] = -1;

\\On inverse la matrice.
m = m^(-1);

\\On applique la récurrence du polynôme n fois
m     = IterN(m,n);
text2 = (m*(text2~));

\\Enfin, on décode !
text2 = decodf27(text2);
print(text2);
