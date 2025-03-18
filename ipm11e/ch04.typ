#import "@preview/fletcher:0.5.6" as fletcher: diagram, node, edge

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
#set figure(numbering: none)
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

The probabilities (transition matrix) are: 

#figure(
  table(
    columns: 5,
    stroke: (x, y) => if x>0 and y>0 {0.5pt},
    $X_n without X_(n+1)$, [*000 - 111*], [*001 - 011*], [*011 - 001*], [*111 - 000*],
    [*000 - 111*],     [0],           [1],           [0],           [0],
    [*001 - 011*],     [1/9],         [4/9],         [4/9],         [0],
    [*011 - 001*],     [0],           [4/9],         [4/9],         [1/9],
    [*111 - 000*],     [0],           [0],           [1],           [0]),
  caption: [1=white, 0=black]  
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

====
The probability distribution of $X_0$ is $bold(x)_0 = mat(1\/4, 1\/4, 1\/2)$. Therefore the distribution of $X_3$ is
$
  bold(x)_3 
    &= bold(x)_0 bold(P)^3 \
    &= mat(1/4, 1/4, 1/2) 
      mat(
        1/2, 1/3, 1/6;
        0,   1/3, 2/3;
        1/2, 0,   1/2)^3 \
    &= mat(59/144, 43/216, 169/432),
$
and
$
  "E"[X_3]  
  &= mat(0,1,2) dot mat(59/144, 43/216, 169/432) \
  &= 53/54.
$

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

====
For $n=1$, the result is immediate. Assume the result holds for $n=k$. Then
$
  bold(P)^(k+1) 
  &= bold(P)^k dot bold(P) \
  &= mat(
    1/2 + 1/2(2p-1)^k, 1/2 - 1/2(2p-1)^k;
    1/2 - 1/2(2p-1)^k, 1/2 + 1/2(2p-1)^k)
    mat(
    p, 1-p;
    1-p, p) \
  &= mat(
    1/2 + 1/2(2p-1)^(k+1), 1/2 - 1/2(2p-1)^(k+1);
    1/2 - 1/2(2p-1)^(k+1), 1/2 + 1/2(2p-1)^(k+1)).
$

Therefore the result holds for arbitrary $n$.

=== 4.7
In Example 4.4, suppose that it has rained neither yesterday nor the day before yesterday. What is the probability that it will rain tomorrow?

====
We need to look at the $P^2_(i,j)$ probabilities:

#import emoji:umbrella, sun

#figure(
  table(
    columns: 5,
    align: center,
    stroke: (x, y) => if x>0 and y>0 {0.5pt},
    [T-2 | T-1 $without$ T | T+1], $umbrella|umbrella$, $sun|umbrella$, $umbrella|sun$, $sun|sun$,
    $umbrella|umbrella$, [0.49], [0.12], [0.21], [0.18],
    $sun|umbrella$, [0.35], [0.2], [0.15], [0.3],
    $umbrella|sun$, [0.2], [0.12], [0.2], [0.48],
    $sun|sun$, [0.1], [0.16], [0.1], [0.64]),
    caption: [T = today]
)

Reading off the last line, the probability that it will rain tomorrow is $0.1 + 0.16 = 0.26$.

=== 4.8
An urn initially contains 2 balls, one of which is red and the other blue. At each stage a ball is randomly selected. If the selected ball is red, then it is replaced with a red ball with probability 0.7 or with a blue ball with probability 0.3; if
the selected ball is blue, then it is equally likely to be replaced by either a red or blue ball.

+ Let $X_n$ equal $1$ if the $n$th ball selected is red, and let it equal $0$ otherwise. Is ${X_n,n >= 1}$ a Markov chain? If so, give its transition probability matrix.

+ Let $Y_n$ denote the number of red balls in the urn immediately before the $n$th ball is selected. Is ${Y_n,n >= 1}$ a Markov chain? If so, give its transition probability matrix.

+  Find the probability that the second ball selected is red.

+  Find the probability that the fourth ball selected is red.

====
+ ${X_n}$ is not a Markov chain. Because the color of the $n$th ball selected does not determine the probability of color of the $(n+1)$th.

+ ${Y_n}$ is a Markov chain with transition probabilities $bold(P)$:
  #figure(
    table(
      columns: 4,
      stroke: (x, y) => if x>0 and y>0 {0.5pt},
      $Y_n without Y_(n+1)$, [*0*],  [*1*],  [*2*],
      [*0*],  $.5$, $.5$, $0$,
      [*1*],  $.5 times .3 = .15$, $.6$, $.5 times .5 = .25$,
      [*2*], $0$, $.3$, $.7$,
    ),
    caption: [state = number of red balls]
  )

+ Looking at the 2nd row of $bold(P)$, the probability that the second ball selected is red is 
  $ .6 times .5 + .25 = .55. $

+ The state probabilities after the 3rd replacement is
  $ mat(0, 1, 0) dot bold(P)^3 = mat(0.159, 0.486, 0.355). $

  So the 4th ball selected is red with probability 
  $ .486 times .5 + .355 = .598. $

=== 4.9
In a sequence of independent flips of a coin that comes up heads with probability 0.6, what is the probability that there is a run of three consecutive heads within the first 10 flips?

====
Let the state represent the current numer of consecutive heads. We also make the state of 3 consecutive heads aborbing to mark that the run has occurred. The transition matrix $bold(P)$ is therefore:

#figure(
  table(
    columns: 5,
    stroke: (x, y) => if x>0 and y>0 {0.5pt},
    $X_n without X_(n+1)$,     [*0*],   [*1*],   [*2*],  [*3*],
    [*0*],                        [0.4],   [0.6],   [0],    [0],
    [*1*],                        [0.4],   [0],     [0.6],  [0],
    [*2*],                        [0.4],   [0],     [0],    [0.6],
    [*3*],                        [0],     [0],     [0],    [1]
  ),
  caption: [state = current number of consecutive heads]
)

Now start from $X_0 = 0$ and let the chain proceed 10 steps. The probability that there is a run of three consecutive heads within the first 10 flips is $ P^10_(0,3) = 0.701361. $

=== 4.10
In Example 4.3, Gary is currently in a cheerful mood. What is the probability that he is not in a glum mood on any of the following three days?

====
Make the glum state (3) absorbing:
$
  bold(P) = mat(
    .5, .4, .1;
    .3, .4, .3;
    0,  0,  1
  )
$

Then the answer is: $1 - P^3_(1,3) = 0.585.$

=== 4.11
In Example 4.13, give the transition probabilities of the $Y_n$ Markov chain in terms of the transition probabilities $P_(i,j)$ of the $X_n$ chain.

====
The probabilities of the $Y_n$ chain is

#figure(
  table(
    columns: 8,
    align: (x, y) => if x==0 {left} else {auto},
    stroke: (x, y) => if x>0 and y>0 {0.5pt},
    $Y_n without Y_(n+1)$, [➀], [➁], [➂], [➃], [➄], [➅], [➆],     
    [➀: 1 step in pattern], $P_11$, $P_12$, $0$, $0$, $0$, $P_10$, $P_13$,
    [➁: 2 steps in pattern] , $0$, $0$, $P_21$, $0$, $P_22$, $P_20$, $P_23$,
    [➂: 3 steps in pattern], $P_11$, $0$, $0$, $P_12$, $0$, $P_10$, $P_13$,
    [➃: pattern seen], $0$, $0$, $0$, $1$, $0$, $0$, $0$,
    [➄: \_\_2, no progress], $P_21$, $0$, $0$, $0$, $P_22$, $P_20$, $P_23$,
    [➅: \_\_0, no progress], $P_01$, $0$, $0$, $0$, $P_02$, $P_00$, $P_03$,
    [➆: \_\_3, no progress], $P_31$, $0$, $0$, $0$, $P_32$, $P_30$, $P_33$
  ),
  caption: [tracking progress in pattern *1212*]
)

=== 4.12
Consider a Markov chain with transition probabilities $q_(i,j), i,j >= 0$. Let $N_(0,k), k != 0$ be the number of transitions, starting in state $0$, until this Markov chain enters state $k$. Consider another Markov chain with transition probabilities $P_(i,j),i,j >= 0$, where
$
  P_(i,j) &= q_(i,j), i != k \
  P_(k,j) &= 0, j != k \
  P_(k,k) &= 1.
$

Give explanations as to whether the following identities are true or false.

+ $Pr{N_(0,k) <= m} = P^m_(0,k)$

+ $Pr{N_(0,k) = m} = sum_(i!=k) P^(m-1)_(0,i) P_(i,k)$

====
Because of the way it's set up, the $bold(P)$ chain is just the original chain but with node $k$ made absorbing.

+ The LHS is the probability that the original chain reaches state $k$ in $m$ steps or less. The RHS is the probability that the modified chain ($k$ made absorbing) is in state $k$ after $m$ steps. They are the same.

+ It is also true. The LHS is the probability that the original chain reaches state $k$ in exactly $m$ steps. To do this, the chain must first go from $0$ to $i, i != k$ in $m-1$ steps, then continue from $i$ to $k$ in a single step. The RHS is the sum of these probabilities over all $i != k$.

=== 4.13 
Let $bold(P)$ be the transition probability matrix of a Markov chain. Argue that if for some positive integer $r$, $bold(P)^r$ has all positive entries, then so does $bold(P)^n$, for all
integers $n >= r$.

====
We only need to argue for the case $n=r+1$, and the rest follows by induction.

Because $bold(P)^r$ has all positive entries, all states are accessible from all states, and no state is isolated. That means the columns of $bold(P)$ cannot be all zeros, i.e. for all $i$, $P_(i,k)>0$ for some $k$. Therefore,

$
  P^(r+1)_(i,j) = sum_(k>=0) P^r_(i,k) P_(k,j) > 0.
$

=== 4.14
Specify the classes of the following Markov chains, and determine whether they are transient or recurrent:

$
  bold(P_1) = mat(
    0, 1/2, 1/2;
    1/2, 0, 1/2;
    1/2, 1/2, 0
  ),
  wide
  bold(P_2) = mat(
    0, 0, 0, 1;
    0, 0, 0, 1;
    1/2, 1/2, 0, 0;
    0, 0, 1, 0
  ), 
$

$
  bold(P_3) = mat(
    1/2, 0, 1/2, 0, 0;
    1/4, 1/2, 1/4, 0, 0;
    1/2, 0, 1/2, 0, 0;
    0, 0, 0, 1/2, 1/2;
    0, 0, 0, 1/2, 1/2;  
  ),
  wide
  bold(P_4) = mat(
    1/4, 3/4, 0, 0, 0;
    1/2, 1/2, 0, 0, 0;
    0, 0, 1, 0, 0;
    0, 0, 1/3, 2/3, 0;
    1, 0, 0, 0, 0;
  ).
$

====
It's easier to see by the graph representation.

#grid(
//  columns: (auto, auto, 1fr),
  columns: 3,
  align: (horizon, center, horizon),
  gutter: 2em,

  $bold(P_1):$,
  diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    $
      1 
      edge("rr", ->, 1/2, label-side: #center) 
      edge("rr", <-, 1/2, bend: #60deg, label-side: #center)
      && 2 
      edge("dl", ->, 1/2, label-side: #center)
      edge("dl", <-, 1/2, bend: #60deg, label-side: #center)
      \ & 3
      edge("ul", ->, 1/2, label-side: #center) 
      edge("ul", <-, 1/2, bend: #60deg, label-side: #center)
    $
  ),
  [All states communicate, so all states belong to the same class which is recurrent.],

  $bold(P_2):$,
  diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    $
      3 
      edge(->, 1/2, label-side: #center) 
      edge("dr", ->, 1/2, label-side: #center)
      edge("rr", <-, 1, bend: #60deg, label-side: #center)
      &2 
      edge(->, 1, label-side: #center) &4 
      edge("dl", <-, 1, label-side: #center)
      \ &1 
    $
  ),
  [All states communicate, so all states belong to the same class which is recurrent.],

  $bold(P_3):$,
  diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    node((0,0), $1$, name: <1>),
    edge(<3>, "->", $1/2$, label-side: center),
    edge(<1>, "->", $1/2$, bend: 320deg, loop-angle: 0deg, label-side: center),
    node((1,0), $2$, name: <2>),
    edge(<1>, "->", $1/4$, label-side: center),
    edge(<3>, "->", $1/4$, label-side: left),
    edge(<2>, "->", $1/2$, bend: 320deg, loop-angle: -90deg, label-side: center),
    node((1,1), $3$, name: <3>),
    edge(<1>, "->", $1/2$, label-side: center, bend: 50deg),
    edge(<3>, "<-", $1/2$, bend: 320deg, loop-angle: 90deg, label-side: center),
    node((2,0), $4$, name: <4>),
    edge(<5>, "->", $1/2$, label-side: center, bend: 50deg),
    edge(<4>, "->", $1/2$, bend: 320deg, loop-angle: -90deg, label-side: center),
    node((2,1), $5$, name: <5>),
    edge(<4>, "->", $1/2$, label-side: center, bend: 50deg),
    edge(<5>, "->", $1/2$, bend: 320deg, loop-angle: 90deg, label-side: center),
  ),
  [
    The chain can be partitioned into 3 classes: 
    - ${2}$ is transient.
    - ${1,3}$ is recurrent.
    - ${4,5}$ is recurrent.
  ],

  $bold(P_4):$,
  diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    node((0,0), $1$, name: <1>),
    edge(<2>, "->", $3/4$, bend: -50deg, label-side: center),
    edge(<1>, "->", $1/4$, bend: 320deg, loop-angle: 0deg, label-side: center),
    node((1,0), $2$, name: <2>),
    edge(<1>, "->", $1/2$, bend: -50deg, label-side: center),
    edge(<2>, "->", $1/2$, bend: 320deg, loop-angle: 180deg, label-side: center),
    node((2,0), $3$, name: <3>),
    edge(<3>, "<-", $1$, bend: 320deg, loop-angle: -90deg, label-side: center),
    node((2,1), $4$, name: <4>),
    edge(<3>, "->", $1/3$),
    edge(<4>, "->", $2/3$, bend: 320deg, loop-angle: 90deg, label-side: center),
    node((0,1), $5$, name: <5>),
    edge(<1>, "->", $1$, label-side: left),
  ),
  [
    The chain can be partitioned into 4 classes: 
    - ${1,2}$ is recurrent.
    - ${5}$ is transient.
    - ${3}$ is recurrent.
    - ${4}$ is transient.
  ]
)

=== 4.15
Consider the random walk of Example 4.19. Suppose that $p > 1\/2$, and let $m_i$ denote the mean number of transitions until the random walk, starting in state $0$, has value $i, i > 0$. Argue that

+ $m_1 = 1 + (1-p)2m_1$

+ Find $m_i, i > 0$.

=== 4.16
Show that if state $i$ is recurrent and state $i$ does not communicate with state $j$, then $P_(i,j) = 0$. This implies that once a process enters a recurrent class of states it can never leave that class. For this reason, a recurrent class is often referred to as a _closed_ class.

====
Suppose $P_(i,j) > 0$, i.e., the chain can go from $i$ to $j$. But it can never come back to $i$, for $i$ does not communicate with $j$. This contradicts the fact that $i$ is recurrent. Hence $P_(i,j) = 0$. 

=== 4.17
For the random walk of Example 4.19 use the strong law of large numbers to give another proof that the Markov chain is transient when $p != 1/2$.

*Hint*: Note that the state at time $n$ can be written as $sum_(i=1)^n Y_i$ where the $Y_i$s are independent and $Pr{Y_i = 1} = p = 1 - Pr{Y_i = -1}$. Argue that if $p > 1/2$, then, by the strong law of large numbers, $sum_(i=1)^n Y_i -> infinity$ as $n -> infinity$ and hence the initial state $0$ can be visited only finitely often, and hence must be transient. A similar argument holds when $p < 1/2$.


