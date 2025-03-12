
#set text(
//  font: "New Computer Modern",
  size: 12pt
)

#show heading.where(
  level: 3
): it => text(
  [Exercise ] + it.body,
)

#show heading.where(
  level: 4
): it => text(
  [Solution] + [:],
)

#set enum(numbering: "(a)")
#set math.mat(gap: 1em)
#set math.mat(delim: "[")


== Markov Chains

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
Each individual in a population independently has a random number of off-spring that is Poisson distributed with mean $lambda$. Those initially present constitute the zeroth generation. Offspring of zeroth generation people constitute the first generation; their offspring constitute the second generation, and so on. If $X_n$ denotes the size of generation $n$, is ${X_n, n >= 0}$ a Markov chain? If it is, give its transition probabilities $P_(i,j)$; if it is not, explain why it is not.

====
${X_n, n >= 0}$ is a Markov chain with
$
  P_(i,j) = e^(-i lambda) (i lambda)^j \/ j!.
$
(The sum of $n$ iid $"Poisson"(lambda)$ random variables is $"Poisson"(n lambda)$).


=== 4.3
There are $k$ players, with player $i$ having value $v_i > 0$, $i = 1,...,k$. In every period, two of the players play a game, while the other $k - 2$ wait in an ordered line. The loser of a game joins the end of the line, and the winner then plays a new game against the player who is first in line. Whenever $i$ and $j$ play, $i$ wins with probability $v_i/(v_i + v_j)$ .

+ Define a Markov chain that is useful in analyzing this model.
+ How many states does the Markov chain have?
+ Give the transition probabilities of the chain.

====
+ To fully capture the gaming scene, the state should include:
  - the pair of players currently having a game, and
  - the ordered queue of players waiting.
  Or in notation:
  $
    (x_1, x_2), x_3, ... x_k,
  $
  where $(x_1, x_2)$ is orderless.

+ There are 
  $
    binom(k, 2)(k-2)! = k!/2
  $
  such states.

+ There are only 2 possibilities going from state $[(x_1, x_2), x_3, ... x_k]$:
  - $x_1$ wins, the chain goes to state $[(x_1, x_3), x_4, ... x_k, x_2]$ with probability $v_1\/(v_1 + v_2)$.
  - $x_1$ loses, the chain goes to state $[(x_2, x_3), x_4, ... x_k, x_1]$ with probability $v_2\/(v_1 + v_2)$.
  All other transition probabilities are 0.

=== 4.4
Let $bold(P)$ and $bold(Q)$ be transition probability matrices on states $1,...,m$, with respective transition probabilities $P_(i,j)$ and $Q_(i,j)$. Consider processes ${X_n,n >= 0}$ and ${Y_n,n >= 0}$ defined as follows:

+ $X_0 = 1$. A coin that comes up heads with probability $p$ is then flipped. If the coin lands heads, the subsequent states $X_1, X_2,...$ are obtained by using the transition probability matrix $bold(P)$; if it lands tails, the subsequent states $X_1, X_2,...$ are obtained by using the transition probability matrix $bold(Q)$. (In other words, if the coin lands heads (tails) then the sequence of states is a Markov chain with transition probability matrix $bold(P)$($bold(Q)$). Is ${X_n,n >= 0}$ a Markov chain? If it is, give its transition probabilities. If it is not, tell why not.

+ $Y_0 = 1$. If the current state is $i$, then the next state is determined by first flipping a coin that comes up heads with probability $p$. If the coin lands heads then the next state is $j$ with probability $P_(i,j)$; if it lands tails then the next state is $j$ with probability $Q_(i,j)$. Is ${Y_n,n >= 0}$ a Markov chain? If it is, give its transition probabilities. If it is not, tell why not.

====
+ No. The chain could be different from run to run.

+ ${Y_n,n >= 0}$ is a Markov chain with transition probabilities
  $
    p bold(P) + (1-p)bold(Q).
  $

=== 4.5
A Markov chain ${X_n,n >= 0}$ with states $0,1,2$ has the transition probability matrix
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


=== 4.7
In Example 4.4, suppose that it has rained neither yesterday nor the day before yesterday. What is the probability that it will rain tomorrow?

=== 4.8
An urn initially contains 2 balls, one of which is red and the other blue. At each stage a ball is randomly selected. If the selected ball is red, then it is replaced with a red ball with probability 0.7 or with a blue ball with probability 0.3; if
the selected ball is blue, then it is equally likely to be replaced by either a red or blue ball.

+ Let $X_n$ equal $1$ if the $n$th ball selected is red, and let it equal $0$ otherwise. Is ${X_n,n >= 1}$ a Markov chain? If so, give its transition probability matrix.

+ Let $Y_n$ denote the number of red balls in the urn immediately before the $n$th ball is selected. Is ${Y_n,n >= 1}$ a Markov chain? If so, give its transition probability matrix.

+  Find the probability that the second ball selected is red.

+  Find the probability that the fourth ball selected is red.

====