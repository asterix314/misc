#set text(
//  font: "New Computer Modern",
  size: 12pt
)

#show heading.where(
  level: 3
): it => text(
  [Exercise ] + it.body + [.],
)

#show heading.where(
  level: 4
): it => text(
  [Solution] + [.],
)

#set enum(numbering: "(a)")
#set math.mat(gap: 1em)
#set math.mat(delim: "[")


== Markov Chains

#lorem(20)

=== 4.1
Three white and three black balls are distributed in two urns in such a way that each contains three balls. We say that the system is in state $i$, $i = 0,1,2,3$, if the first urn contains $i$ white balls. At each step, we draw one ball from each urn and place the ball drawn from the first urn into the second, and conversely with the ball from the second urn. Let $X_n$ denote the state of the system after the $n$th step. Explain why ${X_n, n = 0,1,2,...}$ is a Markov chain and calculate its transition probability matrix.

==== 
It is a Markov chain because $X_(n+1)$ depends only on $X_n$. To see this, note that $X_n$ determines, in turn:
#[#set enum(numbering: "1.")
+ the number of white and black balls in both urns, and so
+ the probabilities of the color of the balls drawn, and so
+ the probabilities of the new state after the balls are switched.
]

Let 1 stand for a white ball and 0 for a black one. The probabilities (transition matrix) are: 

#table(
  columns: 5,
  [before \\ after], [*000 - 111*], [*001 - 011*], [*011 - 001*], [*111 - 000*],
  [*000 - 111*],     [0],           [1],           [0],           [0],
  [*001 - 011*],     [1/9],         [4/9],         [4/9],         [0],
  [*011 - 001*],     [0],           [4/9],         [4/9],         [1/9],
  [*111 - 000*],     [0],           [0],           [1],           [0]
)


=== 4.2
Each individual in a population independently has a random number of off-spring that is Poisson distributed with mean $lambda$. Those initially present constitute the zeroth generation. Offspring of zeroth generation people constitute the first generation; their offspring constitute the second generation, and so on. If $X_n$ denotes the size of generation $n$, is ${X_n, n gt.eq 0}$ a Markov chain? If it is, give its transition probabilities $P_(i,j)$; if it is not, explain why it is not.

====


=== 4.3
There are $k$ players, with player $i$ having value $v_i > 0$, $i = 1,...,k$. In every period, two of the players play a game, while the other $k − 2$ wait in an ordered line. The loser of a game joins the end of the line, and the winner then plays a new game against the player who is first in line. Whenever $i$ and $j$ play, $i$ wins with probability $v_i/(v_i + v_j)$ .

+ Define a Markov chain that is useful in analyzing this model.
+ How many states does the Markov chain have?
+ Give the transition probabilities of the chain.


=== 4.4
Let $bold(P)$ and $bold(Q)$ be transition probability matrices on states $1,...,m$, with respective transition probabilities $P_(i,j)$ and $Q_(i,j)$. Consider processes ${X_n,n gt.eq 0}$ and ${Y_n,n gt.eq 0}$ defined as follows:

+ $X_0 = 1$. A coin that comes up heads with probability $p$ is then flipped. If the coin lands heads, the subsequent states $X_1, X_2,...$ are obtained by using the transition probability matrix $bold(P)$; if it lands tails, the subsequent states $X_1, X_2,...$ are obtained by using the transition probability matrix $bold(Q)$. (In other words, if the coin lands heads (tails) then the sequence of states is a Markov chain with transition probability matrix $bold(P)$($bold(Q)$). Is ${X_n,n gt.eq 0}$ a Markov chain? If it is, give its transition probabilities. If it is not, tell why not.

+ $Y_0 = 1$. If the current state is $i$, then the next state is determined by first flipping a coin that comes up heads with probability $p$. If the coin lands heads then the next state is $j$ with probability $P_(i,j)$; if it lands tails then the next state is $j$ with probability $Q_(i,j)$. Is ${Y_n,n gt.eq 0}$ a Markov chain? If it is, give its transition probabilities. If it is not, tell why not.

====


=== 4.5
A Markov chain ${X_n,n gt.eq 0}$ with states $0,1,2$ has the transition probability matrix
$
  mat(
    1/2, 1/3, 1/6;
    0,   1/3, 2/3;
    1/2, 0,   1/2).
$

If $Pr{X_0 = 0} = Pr{X_0 = 1} = 1/4$, find $"E"[X_3]$.


=== 4.6
Let the transition probability matrix of a two-state Markov chain be given, as in Example 4.2, by
$
  bold(P) = mat(
    p, 1-p;
    1-p, p
  ).
$

Show by mathematical induction that

$
  bold(P)^n = mat(
    1/2 + 1/2(2p-1)^n, 1/2 - 1/2(2p-1)^n;
    1/2 - 1/2(2p-1)^n, 1/2 + 1/2(2p-1)^n
  ).
$
