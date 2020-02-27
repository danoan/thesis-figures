var ('d','R')
a=d*sqrt(1/2)

P1x = a+sqrt(R^2-a^2)	#always positive
Q1y = a+sqrt(R^2-a^2)	#always positive

t1 = arctan2(a,P1x-a)
b1 = arctan2(a,Q1y-a)

g1 = pi*R^2/2 - ( a^2 + (P1x-a)*a + pi*R^2*(t1+b1+pi/2)/(2*pi) )


P2x = sqrt(R^2-a^2)-a	#always positive
Q2y = sqrt(R^2-a^2)-a	#always positive

t2 = arctan2(a,P2x+a)
b2 = arctan2(a,Q2y+a)

g2 = pi*R^2/2 - (pi*R^2/4 - P2x*a - pi*R^2*(t2+b2)/(2*pi) )

f = g1^2-g2^2

plot( g1.subs(R=5),(d,0,5),color='orange',thickness=3,axes_labels=['d','U(p)'] ) + plot( g2.subs(R=5),(d,0,5),color='blue',thickness=3) + plot( (g1+g2).subs(R=5),(d,0,5),color='red',thickness=3)
