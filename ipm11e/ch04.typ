#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge

#set page(
  numbering: "- 1 -"
)

#set text(
  size: 12pt
)

#set table.hline(stroke: .7pt)
#set table.vline(stroke: .7pt)

#set par(justify: true)

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

#let hint(content) = {
  set text(style: "italic")
  [Hint: ] + content
}


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
    1\/2, 1\/3, 1\/6;
    0,   1\/3, 2\/3;
    1\/2, 0,   1\/2).
$

If $Pr{X_0 = 0} = Pr{X_0 = 1} = 1/4$, find $EE[X_3]$.

====
The probability distribution of $X_0$ is $bold(x)_0 = mat(1\/4, 1\/4, 1\/2)$. Therefore the distribution of $X_3$ is
$
  bold(x)_3 
    &= bold(x)_0 bold(P)^3 \
    &= mat(1\/4, 1\/4, 1\/2) 
      mat(
        1\/2, 1\/3, 1\/6;
        0,   1\/3, 2\/3;
        1\/2, 0,   1\/2)^3 \
    &= mat(59\/144, 43\/216, 169\/432),
$
and
$
  EE[X_3]  
  &= mat(0,1,2) dot mat(59\/144, 43\/216, 169\/432) \
  &= 53\/54.
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
    stroke: none,
    [T-2 | T-1 $without$ T | T+1], table.vline(), table.hline(),
    $umbrella|umbrella$, $sun|umbrella$, $umbrella|sun$, $sun|sun$,
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
      $Y_n without Y_(n+1)$, 
              [*0*],  [*1*],  [*2*],
      [*0*],  $.5$, $.5$, $0$,
      [*1*],  $.5 times .3 = .15$, $.6$, $.5 times .5 = .25$,
      [*2*],  $0$, $.3$, $.7$,
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
    stroke: none,
    $X_n without X_(n+1)$, table.vline(), table.hline(),     
            [*0*],   [*1*],   [*2*],  [*3*],
    [*0*],  [0.4],   [0.6],   [0],    [0],
    [*1*],  [0.4],   [0],     [0.6],  [0],
    [*2*],  [0.4],   [0],     [0],    [0.6],
    [*3*],  [0],     [0],     [0],    [1]
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
    stroke: none,
    $Y_n without Y_(n+1)$, table.hline(), table.vline(),
    [➀], [➁], [➂], [➃], [➄], [➅], [➆],     
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
  columns: 3,
  align: (horizon, left, horizon),
  gutter: 1em,
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
    edge(<1>, "->", $1/2$, bend: 310deg, loop-angle: 0deg, label-side: center),
    node((1,0), $2$, name: <2>),
    edge(<1>, "->", $1/4$, label-side: center),
    edge(<3>, "->", $1/4$, label-side: left),
    edge(<2>, "->", $1/2$, bend: 310deg, loop-angle: -90deg, label-side: center),
    node((1,1), $3$, name: <3>),
    edge(<1>, "->", $1/2$, label-side: center, bend: 50deg),
    edge(<3>, "<-", $1/2$, bend: 310deg, loop-angle: 90deg, label-side: center),
    node((2,0), $4$, name: <4>),
    edge(<5>, "->", $1/2$, label-side: center, bend: 50deg),
    edge(<4>, "->", $1/2$, bend: 310deg, loop-angle: -90deg, label-side: center),
    node((2,1), $5$, name: <5>),
    edge(<4>, "->", $1/2$, label-side: center, bend: 50deg),
    edge(<5>, "->", $1/2$, bend: 310deg, loop-angle: 90deg, label-side: center),
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
    edge(<1>, "->", $1/4$, bend: 310deg, loop-angle: 0deg, label-side: center),
    node((1,0), $2$, name: <2>),
    edge(<1>, "->", $1/2$, bend: -50deg, label-side: center),
    edge(<2>, "->", $1/2$, bend: 310deg, loop-angle: 180deg, label-side: center),
    node((2,0), $3$, name: <3>),
    edge(<3>, "<-", $1$, bend: 310deg, loop-angle: -90deg, label-side: center),
    node((2,1), $4$, name: <4>),
    edge(<3>, "->", $1/3$),
    edge(<4>, "->", $2/3$, bend: 310deg, loop-angle: 90deg, label-side: center),
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

====
+ Starting from $0$, if the chain takes one step right, it has arrived at $1$ already; if it takes one step left to $-1$, then it has to move first to $0$ in $m_1$ steps, on average, then to $2$, in another $m_1$ steps. That is,
  $ 
    m_1 &= 1 + p dot 0 + (1-p) dot 2m_1 \
    &= 1 + (1-p)2m_1 \
    &= 1/(2p-1).
  $

+ By the same token, one can write
  $
    m_i &= 1 + p dot (i-1) m_1 + (1-p) dot (i+1)m_1 \
    &= 1 + (i + 1 - 2p)m_1 \
    &= 1 + (i + 1 - 2p)/(2p-1) \
    &= i/(2p-1).
  $

=== 4.16
Show that if state $i$ is recurrent and state $i$ does not communicate with state $j$, then $P_(i,j) = 0$. This implies that once a process enters a recurrent class of states it can never leave that class. For this reason, a recurrent class is often referred to as a _closed_ class.

====
Suppose $P_(i,j) > 0$, i.e., the chain can go from $i$ to $j$. But it can never come back to $i$, for $i$ does not communicate with $j$. This contradicts the fact that $i$ is recurrent. Hence $P_(i,j) = 0$. 

=== 4.17
For the random walk of Example 4.19 use the strong law of large numbers to give another proof that the Markov chain is transient when $p != 1/2$.

 #hint[
  Note that the state at time $n$ can be written as $sum_(i=1)^n Y_i$ where the $Y_i$s are independent and $Pr{Y_i = 1} = p = 1 - Pr{Y_i = -1}$. Argue that if $p > 1/2$, then, by the strong law of large numbers, $sum_(i=1)^n Y_i -> oo$ as $n -> oo$ and hence the initial state $0$ can be visited only finitely often, and hence must be transient. A similar argument holds when $p < 1/2$.
]

====
Let's take the hint and define $Y_i$ as 
$
  Y_i = cases(
    1\, quad &"if" X_i "takes a right step",
    -1\, quad &"otherwise"
  )
$
so that $X_n = sum_(i<=n) Y_i$. Then, by the strong law of large numbers,
$
  X_n &-> n dot EE[Y] \
  &= n(2p-1) "as" n->oo.
$

If $p!=1/2$, this means that $X_n -> plus.minus oo$, so any state can be visited only finitely often, and hence the Markov chain is transient.

=== 4.18
Coin 1 comes up heads with probability 0.6 and coin 2 with probability 0.5. A coin is continually flipped until it comes up tails, at which time that coin is put aside and we start flipping the other one.

+ What proportion of flips use coin 1?

+ If we start the process with coin 1 what is the probability that coin 2 is used on the fifth flip?

+ What proportion of flips land heads?

====
Let ${X_n}$ represent each of the 4 outcomes (coin 1/2 heads/tails), and the transitions matrix $bold(P)$ is:

#grid(
  columns:  (1fr, 1fr),
  align: center + bottom,
  gutter: 1em,
  table(
    columns: 5,
    align: (x, y) => if x==0 {left} else {auto},
    stroke: none,
    $X_n without X_(n+1)$, table.vline(), table.hline(),
            [*H1*], [*T1*], [*H2*], [*T2*],
    [*H1*], [.6],   [.4],   [0],    [0],
    [*T1*], [0],    [0],    [.5],   [.5],
    [*H2*], [0],    [0],    [.5],   [.5],
    [*T2*], [.6],   [.4],   [0],    [0]
  ),
  diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    node-shape: circle,
    node((0,0), [H1], name: <h1>),
    edge(<t1>, "->", [0.4], label-side: center),
    edge(<h1>, "->", [0.6], bend: 310deg, loop-angle: 0deg,label-side: center),
    node((1,0), [T1], name: <t1>),
    edge(<h2>, "->", [0.5], bend: 50deg, label-side: center),
    edge(<t2>, "->", [0.5], bend: 50deg, label-side: center),
    node((1,1), [T2], name: <t2>),
    edge(<h1>, "->", [0.6], bend: 50deg, label-side: center),
    edge(<t1>, "->", [0.4], bend: 50deg, label-side: center),
    node((2,1), [H2], name: <h2>),
    edge(<t2>, "->", [0.5], label-side: center),
    edge(<h2>, "->", [0.5], bend: 310deg, loop-angle: 180deg, label-side: center)
    ),
    [transition matrix],
    [transition graph]
)

+ The long-run proportions are calculated from $bold(P)$ to be: $pi_"H1" = 1\/3$, $pi_"T1" = pi_"H2" = pi_"T2" = 2\/9$. So the proportion of coin 1 is $pi_"H1" + pi_"T1" = 5\/9$.

+ It's the same as starting with the inital state H1 and after 4 flips we land with H2 or T2. The probability of that is
  $ P^4_"H1,H2" + P^4_"H1,T2" = 222/500. $ 

+ $pi_"H1" + pi_"H2" = 5\/9$.

=== 4.19
For Example 4.4, calculate the proportion of days that it rains.

====
Recall in that example, $bold(P)$ was
#figure(
  table(
    columns: 5,
    align: center,
    stroke: none,
    [T-1 | T $without$ T | T+1], table.vline(), table.hline(),
    $umbrella|umbrella$, $sun|umbrella$, $umbrella|sun$, $sun|sun$,
    $umbrella|umbrella$, [.7], [0], [0.3], [0],
    $sun|umbrella$, [.5], [0], [.5], [0],
    $umbrella|sun$, [0], [.4], [0], [.6],
    $sun|sun$, [0], [.2], [0], [0.8]),
    caption: [T = today]
)
and the long-run proportions are:
$ pi_(umbrella|umbrella) = .25, quad pi_(sun|umbrella) = .15, quad pi_(umbrella|sun) = .15, quad pi_(sun|sun) = .45 $

The proportion of rainy days is therefore
$  pi_(umbrella|umbrella) + pi_(sun|umbrella) = .4 $

=== 4.20
A transition probability matrix $bold(P)$ is said to be doubly stochastic if the sum over each column equals one; that is,

$ sum_i P_(i,j) = 1, quad "for all" j $

If such a chain is irreducible and consists of $M + 1$ states $0,1,...,M$, show that the long-run proportions are given by

$ pi_j = 1/(M + 1), quad j = 0,1,...,M. $

====
$pi_j = 1\/(M + 1), quad j = 0,1,...,M$ satisfies the long-run equations:
$ 
  sum_i P_(i,j) pi_i &= 1/(M+1) sum_i P_(i,j) \
  &= 1/(M+1) \
  &= pi_j.
$
By uniqueness they are the long-run proportions.

=== 4.21
A DNA nucleotide has any of four values. A standard model for a mutational change of the nucleotide at a specific location is a Markov chain model that supposes that in going from period to period the nucleotide does not change with probability $1 - 3 alpha$, and if it does change then it is equally likely to change to any of the other three values, for some $0 < alpha < 1$

+ Show that $P^n_(1,1) = 1/4 + 3/4 (1 - 4 alpha)^n$.

+ What is the long-run proportion of time the chain is in each state?

====
+ The transition probabilities are
  $
    P_(i,j) = cases(
      1 - 3 alpha\, & "if" i = j, \
      alpha\, & "if" i != j.
    )
  $
  For $n=1$, the result is apparent. Now assume that the result holds for $n$, then by symmetry,
  $
    P^n_(1,j) = 1/3 (1 - P^n_(1,1)) = 1/4 - 1/4 (1 - 4 alpha)^n, quad j = 2, 3, 4.
  $
  And so
  $
    P^(n+1)_(1,1) &= mat(P^n_(1,1), P^n_(1,2), P^n_(1,3), P^n_(1,4))
      dot vec(1 - 3 alpha, alpha, alpha, alpha) \
    &= (1 - 3 alpha) dot (1/4 + 3/4 (1 - 4 alpha)^n)  + 3 alpha dot (1/4 - 1/4 (1 - 4 alpha)^n) \
    &= 1/4 + 3/4 (1 - 4 alpha)^(n+1).
  $
  By induction, $P^n_(1,1) = 1/4 + 3/4 (1 - 4 alpha)^n$ holds for all $n >= 1$.

+ By symmetry the 4 states must take equal parts in the long-run proportion of time, so $pi_i = 1\/4, i = 1,2,3.4$.

=== 4.22
Let $Y_n$ be the sum of $n$ independent rolls of a fair die. Find
$ lim_(n -> oo) Pr{Y_n "is a multiple of 13"} $

#hint[
  Define an appropriate Markov chain and apply the results of Exercise 20.
]

====
Let $X_n$ be $Y_n$ modulo $13$. Then $X_n$ is a Markov chain with long-run proportions $pi_i, i = 0,1,2,...,12$ and transition probabilities
$
  P_(i,j) = cases(
    1\/6\, quad & i + k equiv j mod 13\, thick k = 1\, 2\, ... 6,
    0\, quad & "otherwise"
    )
$
and
$ lim_(n -> oo) Pr{Y_n "is a multiple of 13"} = pi_0. $

It's easy to verify 
$ sum_j P_(i,j) = 1 "for all" i quad "and" quad sum_i P_(i,j) = 1 "for all" j. $
So Exercise 20 applies and $pi_0 = 1\/13$.

=== 4.23
In a good weather year, the number of storms is Poisson distributed with mean 1; in a bad year it is Poisson distributed with mean 3. Suppose that any year's weather condition depends on past years only through the previous year's condition. Suppose that a good year is equally likely to be followed by either a good or a bad year, and that a bad year is twice as likely to be followed by a bad year as by a good year. Suppose that last year — call it year 0 — was a good year.

+ Find the expected total number of storms in the next two years (that is, in years 1 and 2).

+ Find the probability there are no storms in year 3.

+ Find the long-run average number of storms per year.

+ Find the proportion of years that have no storms.

====
There are 2 states, "good" and "bad", and the transition matrix is

#figure(
  table(
    columns: 3,
    stroke: none,
    $X_n without X_(n+1)$, table.vline(), table.hline(),
                [*good*], [*bad*],
    [*good*],   $1\/2$,    $1\/2$,
    [*bad*],    $1\/3$,    $2\/3$
  ),
  caption: [transition matrix $bold(P)$]
)

+ The state probabilities for year 1 is $mat(1\/2, 1\/2)$, so expect $ 1/2 dot 1 + 1/2 dot 3 = 2 $ storms in year 1. Similarly, the state probabilities for year 2 is $mat(1\/2, 1\/2) dot bold(P) = mat(5\/12, 7\/12)$, so expect $ 5/12 dot 1 + 7/12 dot 3 = 13/6 $ storms in year 2. The expected total number of storms is therefore $2 + 13\/6 = 25\/6$.

+ The state probabilities for year 3 is 
  $ mat(1,0) dot bold(P)^3 = mat(5\/12, 7\/12) = mat(29\/72, 43\/72). $
  The probability of no storms is
  $ 
    & 29/72 dot e^(-1) 1^0/0! + 43/72 dot e^(-3) 3^0/0! \ 
    =& 29/72 e^(-1) + 43/72 e^(-3) \
    approx& 0.1779
  $

+ The long-run proportions can be calculated from $bold(P)$:
  $ pi_"good" = 2/5, quad pi_"bad" = 3/5. $
  So the long-run average storms per year is 
  $ 2/5 dot 1 + 3/5 dot 3 = 11/5. $

+ $ 
    & 2/5 dot e^(-1) 1^0/0!  + 3/5 dot e^(-3) 3^0/0! \
   =& 2/5 e^(-1) + 3/5 e^(-3) \
   approx& 0.1770
  $

=== 4.24
Consider three urns, one colored red, one white, and one blue. The red urn contains 1 red and 4 blue balls; the white urn contains 3 white balls, 2 red balls, and 2 blue balls; the blue urn contains 4 white balls, 3 red balls, and 2 blue balls. At the initial stage, a ball is randomly selected from the red urn and then returned to that urn. At every subsequent stage, a ball is randomly selected from the urn whose color is the same as that of the ball previously selected and is then returned to that urn. In the long run, what proportion of the selected balls are red? What proportion are white? What proportion are blue?

====
Let $X_n$ represent the color of the $n$th ball selected. The state transition probabilities are:

#figure(
  table(
    columns: 4,
    stroke: none,
    $X_n without X_(n+1)$, table.vline(), table.hline(), 
            [*R*],  [*B*],  [*W*], 
    [*R*],  $1\/5$, $4\/5$, $0$,
    [*B*],  $3\/9$, $2\/9$, $4\/9$,
    [*W*],  $2\/7$, $2\/7$, $3\/7$,           
  ),
  caption: [R = red, B = blue, W = white]  
)

The long-run proportions $pi_i$ satisfy
$
  pi_"R" &= 1/5 pi_"R" + & 3/9 pi_"B" + 2/7 pi_"W" \
  pi_"B" &= 4/5 pi_"R" + & 2/9 pi_"B" + 2/7 pi_"W" \
  pi_"W" &=              & 4/9 pi_"B" + 3/7 pi_"W"
$
giving
$ pi_"R" = 25/89, quad pi_"B" = 36/89, quad pi_"W" = 28/89. $

=== 4.25
Each morning an individual leaves his house and goes for a run. He is equally likely to leave either from his front or back door. Upon leaving the house, he chooses a pair of running shoes (or goes running barefoot if there are no shoes at the door from which he departed). On his return he is equally likely to enter, and leave his running shoes, either by the front or back door. If he owns a total of $k$ pairs of running shoes, what proportion of the time does he run barefooted?

====
Let $X_n$ denote, at the start of day $n$, the number of pairs of shoes at door 1 (front or back) from which the individual leaves the house. Then ${X_n}$ is a Markov chain with transition probabilities arising from 4 scenarios:

#figure(table(
  columns: 3,
  align: center + horizon,
  stroke: 0.5pt,
  [*today returns \ to door*], [*tomorrow leaves \ from door*], [*probability*],
  [1],  [1],  $P_(i,i) &= 1\/4$,
  [1],  [2],  $P_(i, k-i) = 1\/4$,
  [2],  [1],  $P_(i,max(i-1,0)) = 1\/4$,
  [2],  [2],  $P_(i,min(k-i+1,k)) = 1\/4$
  ),
  caption: [door 2 = the other door.]
)

Because every sceanrio contributes to each column of the transition matrix exactly once (when different scenarios refer to the same transition, the probabilities should be added for that transition), this Markov chain is doubly stochastic (Exercise 4.20). Therefore the long-run proportion of state $0$ (runner runs barefooted) is $1\/(k+1)$.

=== 4.26
Consider the following approach to shuffling a deck of $n$ cards. Starting with any initial ordering of the cards, one of the numbers $1,2,...,n$ is randomly chosen in such a manner that each one is equally likely to be selected. If number $i$ is chosen, then we take the card that is in position $i$ and put it on top of the deck — that is, we put that card in position $1$. We then repeatedly perform the same operation. Show that, in the limit, the deck is perfectly shuffled in the sense that the resultant ordering is equally likely to be any of the $n!$ possible orderings.

====
Let $X_n$ denote the ordering of the deck after $n$ operations. Then ${X_n}$ is a Markov chain with state space equal to the set of all $n!$ possible orderings of the deck. 

To show that the chain is irreducible, note that any ordering $S_i$ can be transformed into any other ordering $S_j = j_1, j_2, ... j_n$ by choosing, in turn, the numbers $j_n, j_(n-1) ... j_1$ from $S_i$.

To show that the chain is doubly stochastic, note that $S_j$ can be directly reached, with probability $1\/n$, from each of exactly $n$ states, namely those obtained by moving $j_1$ to the $k$th ($k=1,2,...n$) position within $S_j$. E.g., with $k=3$, the ordering $j_2,j_3,j_1, j_4, j_5 ... j_n$ goes to $S_j$ with probability $1\/n$.

Because the chain is both irreducible and doubly stochastic, the stationary distribution is uniform. That is, in the limit, the resultant ordering is equally likely to be any of the $n!$ possible orderings.

=== 4.27
Each individual in a population of size $N$ is, in each period, either active or inactive. If an individual is active in a period then, independent of all else, that individual will be active in the next period with probability $alpha$. Similarly, if an individual is inactive in a period then, independent of all else, that individual will be inactive in the next period with probability $beta$. Let $X_n$ denote the number
of individuals that are active in period $n$.

+ Argue that ${X_n,n >= 0}$ is a Markov chain.

+ Find $EE[X_n | X_0 = i]$.

+ Derive an expression for its transition probabilities.

+ Find the long-run proportion of time that exactly $j$ people are active. #hint[Consider first the case where $N = 1$.]

====
+ ${X_n}$ is a Markov chain because the state at time $n$ (number of active individuals) depends only on the previous state and not any states prior to that.

+ The transition matrix $bold(Q)$ of an individual is
  #figure(table(
    columns: 3,
    stroke: none,
    $Y_n without Y_(n+1)$, table.vline(), table.hline(),
                    [*active*], [*inactive*],
    [*active*],     $alpha$,    $1 - alpha$,
    [*inactive*],   $1 - beta$, $beta$,
    ),
  )

  Initially there are $i$ active and $N-i$ inactive individuals.

  $
    mat(i, N-i) dot mat(alpha, 1-alpha; 1-beta, beta)^n
  $

+  

+


=== 4.28
Every time that the team wins a game, it wins its next game with probability 0.8; every time it loses a game, it wins its next game with probability 0.3. If the team wins a game, then it has dinner together with probability 0.7, whereas if the team loses then it has dinner together with probability 0.2. What proportion of games result in a team dinner?

====
The transition matrix is
$
  bold(P) = mat(.8, .2; .3, .7),
$
with long-run proportions
$
  pi_"win" = .6, quad pi_"lose" = .4 
$

The proportion of games resuling in a team dinner is therefore
$
  .6 times .7 + .4 times .2 = .5
$

=== 4.29
Whether or not it rains follows a 2 state Markov chain. If it rains one day, then it will rain the next with probability $1\/2$ or will be dry with probability $1\/2$. Overall, 40 percent of days are rainy. If it is raining on Monday, find the probability that it will rain on Thursday.

====
We need to know the probability of rain next day if today is a dry day. Let's call it $q$. Then the transition matrix is
$
  bold(P) = mat(1\/2, 1\/2; q, 1-q).
$
Given long-run proportions $mat(2\/5, 3\/5)$, it must be that
$
  mat(2\/5, 3\/5) dot mat(1\/2, 1\/2; q, 1-q) = mat(2\/5, 3\/5),
$
yeilding $q = 1\/3$, and
$
  bold(P)^3 = mat(29\/72, 43\/72; 43\/108, 65\/108).
$
Therefore it will rain with probability $29\/72$ on Thursday.


=== 4.30
J plays a new game every day. If J wins a game, then she wins the next one with probability 0.6; if she has lost the last game but won the one preceding it, then she wins the next with probability 0.7; if she has lost the last 2 games, then she wins the next with probability 0.2.

+ What proportion of games does J win?

+ Suppose J has been playing a long time. If J loses her game on Monday, what is the probability she will win on Tuesday?

====
The transition probabilities are

#figure(table(
  columns: 5,
  stroke: none,
  $X_n without X_(n+1)$, table.hline(), table.vline(),
          [*WW*], [*LW*], [*WL*], [*LL*],
  [*WW*], [.6],   [0],    [.4],   [0],
  [*LW*], [.6],   [0],    [.4],   [0],
  [*WL*], [0],    [.7],   [0],    [.3],
  [*LL*], [0],    [.2],   [0],    [.8]
  ),
  caption: [W=win, L=lose]  
)
with stationary distribution
$
  pi_"WW" = .3, quad pi_"LW" = .2, quad pi_"WL" = .2, quad pi_"LL" = .3
$

+ $
  pi_"WW" dot 1 + (pi_"LW" + pi_"WL") dot 1/2  = .5
  $

+ $ 
  (pi_"WL" dot P_("WL","LW") + pi_"LL" dot P_("LL", "LW"))/(pi_"WL" + pi_"LL")  = .4
  $


=== 4.31
A certain town never has two sunny days in a row. Each day is classified as being either sunny, cloudy (but dry), or rainy. If it is sunny one day, then it is equally likely to be either cloudy or rainy the next day. If it is rainy or cloudy one day, then there is one chance in two that it will be the same the next day, and if it changes then it is equally likely to be either of the other two possibilities. In the long run, what proportion of days are sunny? What proportion are cloudy?

====
The transition matrix is

#figure(table(
  columns: 4,
  stroke: none,
  $X_n without X_(n+1)$, table.vline(), table.hline(),
          [*S*], [*C*], [*R*],
  [*S*],  [0],   [.5],  [.5],
  [*C*],  [.25], [.5],  [.25],
  [*R*],  [.25], [.25], [.5]
  ),
  caption: [S=sunny, C=cloudy, R=rainy]  
)
with stationary distribution
$ pi_"S" = .2, quad pi_"C" = .4, quad pi_"R" = .4 $


=== 4.32
Each of two switches is either on or off during a day. On day $n$, each switch will independently be on with probability

$ [1 + "number of on switches during day" n − 1]\/4 $

For instance, if both switches are on during day $n − 1$, then each will independently be on during day $n$ with probability $3\/4$. What fraction of days are both switches on? What fraction are both off?

====
Let $X_n$ be the number of on switches during day $n$. The transition matrix is therefore

#figure(table(
  columns: 4,
  stroke: none,
  $X_n without X_(n+1)$, table.vline(), table.hline(), 
          [*0*],    [*1*],     [*2*],
  [*0*],  $9\/16$,  $6\/16$,   $1\/16$,
  [*1*],  $1\/4$,  $1\/2$,   $1\/4$,
  [*2*],  $1\/16$,  $6\/16$,   $9\/16$)
)
with stationary distribution
$ pi_0 = 2/7, quad pi_1 = 3/7, quad pi_2 = 2/7. $

So both switches are on $2\/7$ of the days, and both switches are off another $2\/7$ of the days.


=== 4.33
Two players are playing a sequence of points, which begin when one of the players serves. Suppose that player 1 wins each point she serves with probability $p$, and wins each point her opponent serves with probability $q$. Suppose the winner of a point becomes the server of the next point.

+ Find the proportion of points that are won by player 1.

+ Find the proportion of time that player 1 is the server.

====
Let $X_n in {1,2}$ be the server in game $n$. The transition matrix is then $ bold(P) = mat(p, 1-p; q, 1-q) $ and the stationary distribution $ pi(bold(P)) = mat(q/(1+q-p), (1-p)/(1+q-p)). $

Because a player becomes the server when she wins a point, the proportion of points she won is the same as the proportion of time served. For player 1 this proportion is $pi_1 = q/(1+q-p)$.


=== 4.34
A flea moves around the vertices of a triangle in the following manner: Whenever it is at vertex $i$ it moves to its clockwise neighbor vertex with probability $p_i$ and to the counterclockwise neighbor with probability $q_i = 1 - p_i, i = 1,2,3$.

+ Find the proportion of time that the flea is at each of the vertices.

+ How often does the flea make a counterclockwise move that is then followed by five consecutive clockwise moves?

====
Let $X_n$ denote the vertex the flea has arrived after $n$ moves. 

#grid(
  columns:  (1fr, 1fr),
  align: center + horizon,
  gutter: 1em,
  $
    bold(P) = mat(
      0,    q_1,  p_1;
      p_2,  0,    q_2;
      q_3,  p_3,  0
    )
  $,
  diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    $
      &1 
      edge("dl",->, q_1, label-side: #center) 
      edge("dr",->, p_1, bend: #50deg, label-side: #center) \
      2 
      edge("rr", ->, q_2, label-side: #center) 
      edge("ur", ->, p_2, bend: #50deg, label-side: #center) 
      &&3
      edge("ul", ->, q_3, label-side: #center)
      edge("ll", ->, p_3, bend: #40deg, label-side: #center) 
    $
    )
)

+ The proportions of time are the stationary probabilities
  $
    pi(bold(P)) = vec(
      1 - q_2 p_3,
      1 - p_1 q_3, 
      1 - q_1 p_2
    )^"T" \/ (3 - p_2 q_3 - p_3 + p_1 (p_2 + p_3 - 1))
  $

+ Depending on the starting state, the probabilities are:
  #figure(table(
    columns: 2,
    stroke: none,
    $i$, table.vline(), table.hline(),
          $Pr{arrow.ccw #box($arrow.cw$)^5 | "starts from" i}$,
    $1$,  $pi_1 q_1 p_2^2 p_1^2 p_3$,
    $2$,  $pi_2 q_2 p_3^2 p_2^2 p_1$,
    $3$,  $pi_3 q_3 p_1^2 p_3^2 p_2$
  ))

  Therefore on average, the flea makes a counterclockwise move followed by five consecutive clockwise moves once every
  $
    1\/(pi_1 q_1 p_2^2 p_1^2 p_3 + pi_2 q_2 p_3^2 p_2^2 p_1 + pi_3 q_3 p_1^2 p_3^2 p_2)
  $
  moves.

=== 4.35
Consider a Markov chain with states $0, 1, 2, 3, 4$. Suppose $P_(0,4) = 1$; and suppose that when the chain is in state $i,i > 0$, the next state is equally likely to be any of the states $0,1,...,i-1$. Find the limiting probabilities of this Markov chain.

====
The transition matrix
$
  bold(P) = mat(
    0,    0,    0,    0,    1;
    1,    0,    0,    0,    0;
    1\/2, 1\/2, 0,    0,    0;
    1\/3, 1\/3, 1\/3, 0,    0;
    1\/4, 1\/4, 1\/4, 1\/4, 0).
$

It's easy to check that the chain is both irreducible and aperiodic, so the limiting probabilities follow the stationary distribution
$ 
  P^oo_(i,dot) = pi(bold(P)) = mat(12, 6, 4, 3, 12) \/ 37. 
$


=== 4.36
The state of a process changes daily according to a two-state Markov chain. If the process is in state $i$ during one day, then it is in state $j$ the following day with probability $P_(i,j)$, where
$ P_(0,0) = 0.4, quad P_(0,1) = 0.6, quad P_(1,0) = 0.2, quad P_(1,1) = 0.8 $

Every day a message is sent. If the state of the Markov chain that day is $i$ then the message sent is "good" with probability $p_i$ and is "bad" with probability $q_i = 1 - p_i, i = 0,1$.

+ If the process is in state $0$ on Monday, what is the probability that a good message is sent on Tuesday?

+ If the process is in state $0$ on Monday, what is the probability that a good message is sent on Friday?

+ In the long run, what proportion of messages are good?

+ Let $Y_n$ equal $1$ if a good message is sent on day $n$ and let it equal $2$ otherwise. Is ${Y_n,n >= 1}$ a Markov chain? If so, give its transition probability matrix. If not, briefly explain why not.


====
+ $
    mat(1,0) dot bold(P) dot vec(p_0, p_1) = 0.4 thin p_0 + 0.6 thin p_1
  $

+ $
    mat(1,0) dot bold(P)^4 dot vec(p_0, p_1) = 0.2512 thin p_0 + 0.7488 thin p_1
  $

+ $
    pi(bold(P)) dot vec(p_0, p_1) = 0.25 thin p_0 + 0.75 thin p_1
  $

+ No, because knowing $Y_n$ cannot determine the probability of $Y_(n+1)$, since the underlying process could be in either the $0$ or $1$ state.
