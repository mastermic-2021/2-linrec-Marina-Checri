u27 = ffgen(('x^3-'x+1)*Mod(1,3),'u);
codf27(s) = [if(x==32,0,u27^(x-97))|x<-Vec(Vecsmall(s)),x==32||x>=97&&x<=122];

/* ****************************************************************************** */
/* *********************************** Idées : ********************************** */
/* ****************************************************************************** */

\\on doit déterminer une suite récurrente définie à partir du polynôme p.
\\Pour cela, utiliser le cours sur les suites récurrentes linéaires... ?

\\Que faut-il comprendre sur les indices n+i et (n-40)+i ??

/* ****************************************************************************** */
/* **************************** Posons nos données : **************************** */
/* ****************************************************************************** */

\\n=929583887302112
\\p=x^40+x+u
\\sur F27=F3[u]/u^3-u+1


\\p=x^40+x+u;
\\A quoi correspondent le x et le u ...?
\\cela signifie-t-il que p est une racine de quelque chose ?
\\Et qu'en est-il du polynôme u^3-u+1 ...??

u;
polynome(x,u) = x^40+x+u;
p=[1,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,1, u];
\\ou y a-t-il une meilleure façon de représenter p ...??

/* ****************************************************************************** */

/* * D'après l'indication d'Adèle : 
    on applique la récurrence du polynôme p autant de fois qu'indiqué (= n fois).

   * Comme vu en cours, on calcule les nb premiers termes de la suite (u_n), 
    qui possède le polynome annulateur annul(x) ...?
*/

suite_rec_lineaire(u_0,annul,nb) = {
  if(type(annul)=="t_POL",annul=Vecrev(annul));
  d = #annul - 1;
  if(type(u_0)=="t_POL",u_0=Vecrev(u,d));
  v = Vec(u_0,nb);
  for(k=d,nb, v[k] = -sum(i=1,d,v[k-d+i]*annul[i]));
  v;
}

\\suite_rec_lineaire([],p,n);

\\Il doit y avoir quelque chose à faire avec suite_rec_lineaire, p et n ... !?!?



/* ****************************************************************************** */
/* *************************** Application de cela : **************************** */
/* ****************************************************************************** */


text="lkttoafqagecglgkflpanbgkacwudnvnxreaspmx";
text2=snpmmgzhfsqrmevdkajq hvxxnixufdeiheiurgq;
n=929583887302112;

text=codf27(text);

\\printf(text);




