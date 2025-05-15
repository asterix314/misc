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

// #show heading.where(
//   level: 3
// ): it => text(
//   [Exercise ] + it.body,
// )

#show heading.where(
  level: 4
): it => text(
  [Solution] + [:],
)

#set enum(numbering: "(a)")
#set figure(numbering: none)
#set math.mat(gap: 1em)
#set math.cases(gap: 0.5em)

#let hint(content) = {
  set text(style: "italic")
  [Hint: ] + content
}

#show heading.where(level: 3): it => {
  grid(
    columns: 2,
    gutter: 1em,
    align: horizon,
    [],[],
    [Exercise #it.body], line(length: 100%, stroke: .7pt)
  )
}

#let th(n) = box[$italic(#n)$th]

== Markov Chains

=== 4.1
Three white and three black balls are distributed in two urns in such a way that each contains three balls. We say that the system is in state $i$, $i = 0,1,2,3$, if the first urn contains $i$ white balls. At each step, we draw one ball from each urn and place the ball drawn from the first urn into the second, and conversely with the ball from the second urn. Let $X_n$ denote the state of the system after the #th[n] step. Explain why ${X_n, n = 0,1,2,...}$ is a Markov chain and calculate its transition probability matrix.

====
It is a Markov chain because $X_(n+1)$ depends only on $X_n$. To see this, note that $X_n$ determines, in turn: #[
#set enum(numbering: "1.")
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
An urn initially contains 2 balls, one of which is red and the other blue. At each stage a ball is randomly selected. If the selected ball is red, then it is replaced with a red ball with probability 0.7 or with a blue ball with probability 0.3; if the selected ball is blue, then it is equally likely to be replaced by either a red or blue ball.

+ Let $X_n$ equal $1$ if the #th[n] ball selected is red, and let it equal $0$ otherwise. Is ${X_n,n >= 1}$ a Markov chain? If so, give its transition probability matrix.

+ Let $Y_n$ denote the number of red balls in the urn immediately before the #th[n] ball is selected. Is ${Y_n,n >= 1}$ a Markov chain? If so, give its transition probability matrix.

+  Find the probability that the second ball selected is red.

+  Find the probability that the fourth ball selected is red.

====
+ ${X_n}$ is not a Markov chain. Because the color of the #th[n] ball selected does not determine the probability of color of the #th[(n+1)].

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
    1 quad &"if" X_i "takes a right step",
    -1 quad &"otherwise"
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
      1 - 3 alpha quad & "if" i = j,
      alpha quad & "if" i != j
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
    1\/6 quad & i + k equiv j mod 13\, thick k = 1\, 2\, ... 6,
    0 quad & "otherwise"
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

+ $display(
    & 2/5 dot e^(-1) 1^0/0!  + 3/5 dot e^(-3) 3^0/0! \
   =& 2/5 e^(-1) + 3/5 e^(-3) \
   approx& 0.1770)$

=== 4.24
Consider three urns, one colored red, one white, and one blue. The red urn contains 1 red and 4 blue balls; the white urn contains 3 white balls, 2 red balls, and 2 blue balls; the blue urn contains 4 white balls, 3 red balls, and 2 blue balls. At the initial stage, a ball is randomly selected from the red urn and then returned to that urn. At every subsequent stage, a ball is randomly selected from the urn whose color is the same as that of the ball previously selected and is then returned to that urn. In the long run, what proportion of the selected balls are red? What proportion are white? What proportion are blue?

====
Let $X_n$ represent the color of the #th[n] ball selected. The state transition probabilities are:

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

To show that the chain is doubly stochastic, note that $S_j$ can be directly reached, with probability $1\/n$, from each of exactly $n$ states, namely those obtained by moving $j_1$ to the #th[k] ($k=1,2,...n$) position within $S_j$. E.g., with $k=3$, the ordering $j_2,j_3,j_1, j_4, j_5 ... j_n$ goes to $S_j$ with probability $1\/n$.

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
                    [*1*], [*2*],
    [*1*],     $alpha$,    $1 - alpha$,
    [*2*],   $1 - beta$, $beta$,
    ),
    caption: [1=active, 2=inactive]
  )

  So $Q^n_(1,1)$ is the probability of being active after $n$ periods, given that the individual was initially active; and $Q^n_(2,1)$ is the probability of being active, given that she was initially inactive. It follows that 
  $
    EE[X_n | X_0 = i] &= i Q^n_(1,1) + (N-i) Q^n_(2,1) \
    &= i (alpha + beta -1)^n + (N(1-beta)(1-(alpha + beta - 1)^n))/(2 - alpha - beta)
    
  $

+ For the number of active individuals to change from $i$ to $j$ in one step, it must be the case that
  - $k$ of the $i$ active individuals remain active, for some $k tilde "Bin"(i, alpha)$; and
  - $j-k$ of the $N-i$ inactive individuals become active, for some $(j-k) tilde "Bin"(N-i, 1-beta)$.

  And so the total probability is to sum up all the $k$:
  $
    P_(i,j) = sum^j_(k=0) 
    binom(i, k) alpha^k (1-alpha)^(i-k)
    binom(N-i, j-k) beta^(N-i-j+k) (1-beta)^(j-k)
  $

+ It is infeasable to directly solve for $pi(bold(P))$ based on $bold(P)$. But in the long run, each individual is an iid Bernoulli with $mat(p, 1-p) = pi(bold(Q))$ yielding
  $ p = (1-beta)/(2 - alpha - beta) $
  And therefore $pi(bold(P))$ must be $"Bin"(N, p)$. That is,
  $
    Pr{X_oo = j} = binom(N, j) p^j (1-p)^(N-j)
  $


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

+ $display(
  pi_"WW" dot 1 + (pi_"LW" + pi_"WL") dot 1/2  = .5)$

+ $display(
  (pi_"WL" dot P_("WL","LW") + pi_"LL" dot P_("LL", "LW"))/(pi_"WL" + pi_"LL")  = .4)$


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
    $)
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
+ $display(
    mat(1,0) dot bold(P) dot vec(p_0, p_1) = 0.4 thin p_0 + 0.6 thin p_1)$

+ $display(
    mat(1,0) dot bold(P)^4 dot vec(p_0, p_1) = 0.2512 thin p_0 + 0.7488 thin p_1)$

+ $display(
    pi(bold(P)) dot vec(p_0, p_1) = 0.25 thin p_0 + 0.75 thin p_1)$

+ No, because knowing $Y_n$ cannot determine the probability of $Y_(n+1)$, since the underlying process could be in either the $0$ or $1$ state.

=== 4.37
Show that the stationary probabilities for the Markov chain having transition probabilities $P_(i,j)$ are also the stationary probabilities for the Markov chain whose transition probabilities $Q_(i,j)$ are given by $ Q_(i,j) = P^k_(i,j) $ for any specified positive integer $k$.

====
$
   pi(bold(P)) dot bold(Q) = pi(bold(P)) dot bold(P)^k = pi(bold(P)) dot bold(P)^(k-1) = dots.c = pi(bold(P)).
$

=== 4.38
Capa plays either one or two chess games every day, with the number of games that she plays on successive days being a Markov chain with transition probabilities
$
  P_(1,1) = 0.2, quad  P_(1,2) = 0.8, quad P_(2,1) = 0.4, quad P_(2,2) = 0.6
$

Capa wins each game with probability $p$. Suppose she plays two games on Monday.

+ What is the probability that she wins all the games she plays on Tuesday?

+ What is the expected number of games that she plays on Wednesday?

+ In the long run, on what proportion of days does Capa win all her games.

====
$
  bold(P) = mat(.2, .8; .4, .6).
$

+ $display(mat(0, 1) dot bold(P) dot vec(p, p^2) = 0.4 thin p + 0.6 thin p^2)$

+ $display(mat(0, 1) dot bold(P)^2 dot vec(1, 2) = 1.68)$

+ $display(pi(bold(P)) dot vec(p, p^2) = p/3 + (2 p^2)/3)$


=== 4.39
Consider the one-dimensional symmetric random walk of Example 4.19, which was shown in that example to be recurrent. Let $pi_i$ denote the long-run proportion of time that the chain is in state $i$.

+ Argue that $pi_i = pi_0$ for all $i$.

+ Show that $sum_i pi_i !=1$.

+ Conclude that this Markov chain is null recurrent, and thus all $pi_i = 0$.

====
+ $pi_i = pi_0$ follows from the standpoint of symmetry.

+ $display(sum_i pi_i = sum_i pi_0 = cases(
    0 quad &"if" pi_0 = 0,
    oo quad &"if" pi_0 > 0
  ))$

+ Because there is no solution to $sum_i pi_i =1$ and the Markov chain is clearly recurrent, by Theorem 4.1 we conclude that it is null recurrent and all $pi_i = 0$. 

=== 4.40
A particle moves on 12 points situated on a circle. At each step it is equally likely to move one step in the clockwise or in the counterclockwise direction. Find the mean number of steps for the particle to return to its starting position.

====
By symmetry, $pi_i = 1\/12$. Therefore the mean number of steps for the particle to return to its starting position $m_i = 1\/pi_i = 12$.


=== 4.41
Consider a Markov chain with states equal to the nonnegative integers, and suppose its transition probabilities satisfy $P_(i,j) = 0$ if $j <= i$. Assume $X_0 = 0$, and let $e_j$ be the probability that the Markov chain is ever in state $j$. (Note that $e_0 = 1$ because $X_0 = 0$.) Argue that for $j > 0$
$
  e_j = sum^(j-1)_(i=0) e_i P_(i,j)
$

If $P_(i,i+k) = 1\/3, thick k = 1,2,3$, find $e_i$ for $i = 1, ..., 10$.

====
It is obvious that $ e_j = sum^(j-1)_(i=0) e_i P_(i,j)$. And from $e_0 = 1$, we have the recurrence
$
e_1 &= 1\/3 \
e_2 &= 1/3 (1+1/3) = 4/9 \
e_i &= 1/3(e_(i-1) + e_(i-2) + e_(i-3))
$
which has the solution
$
  e_n = 1/4 ((-1/3 - (i sqrt(2))/3)^n + (-1/3 + (i sqrt(2))/3)^n + 2)
$
And
$
  {e_n} = {1, 1/3, 4/9, 16/27, 37/81, 121/243, 376/729, 1072/2187, 3289/6561, 9889/19683, 29404/59049, ...}
$


=== 4.42
Let $A$ be a set of states, and let $A^c$ be the remaining states.

+ What is the interpretation of $sum_(i in A) sum_(j in A^c) pi_i P_(i,j)$ ?

+ What is the interpretation of $sum_(i in A^c) sum_(j in A) pi_i P_(i,j)$ ?

+ Explain the identity
  $ sum_(i in A) sum_(j in A^c) pi_i P_(i,j) = sum_(i in A^c) sum_(j in A) pi_i P_(i,j) $

====
If we the states in $A$ are collapsed into a single state and the rest into another state $A^c$, the Markov chain simplifies to:

#figure(
  diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    node-shape: circle,
    node((1,0), $A^c$, name: <Ac>),
    edge("->", label-side: center, bend: 40deg),
    edge(<Ac>, "->", label-side: center, bend: -320deg, loop-angle: 0deg),
    node((0, 0), $A$, name: <A>),
    edge(<Ac>, "->", label-side: center, bend: 40deg),
    edge(<A>, "->", label-side: center, bend: 320deg, loop-angle: 0deg)
  ),
  caption: [collapsed Markov chain]
)

It is then easy to see that

+ $sum_(i in A) sum_(j in A^c) pi_i P_(i,j) = pi_A P_(A, A^c)$ is the long-run rate of transitions from $A$ to $A^c$.

+ $sum_(i in A^c) sum_(j in A) pi_i P_(i,j) = pi_(A^c) P_(A^c,A)$ is the long-run rate of transitions from $A^c$ to $A$.

+ The above 2 rates must be equal for the static proportions $pi_A$ and $pi_(A^c)$ to remain constant --- whatever goes out must be replenished fully by what comes in.


=== 4.43
Each day, one of $n$ possible elements is requested, the #th[i] one with probability $P_i,i >= 1, sum^n_1 P_i = 1$. These elements are at all times arranged in an ordered list that is revised as follows: The element selected is moved to the front of the list with the relative positions of all the other elements remaining unchanged. Define the state at any time to be the list ordering at that time and note that there are $n!$ possible states.

+ Argue that the preceding is a Markov chain.

+ For any state $i_1,...,i_n$ (which is a permutation of $1,2,...,n$), let $pi(i_1,...,i_n)$ denote the limiting probability. In order for the state to be $i_1,...,i_n$, it is necessary for the last request to be for $i_1$, the last non-$i_1$ request for $i_2$, the last non-$i_1$ or $i_2$ request for $i_3$, and so on. Hence, it appears intuitive that
  $
  pi(i_1,...,i_n) = P_(i_1) P_(i_2)/(1 - P_(i_1)) thick P_(i_3)/(1 - P_(i_1) - P_(i_2)) thick dots.c thick P_(i_(n-1))/(1 - P_(i_1) - dots.c - P_(i_(n-2)))
  $
  Verify when $n = 3$ that the preceding are indeed the limiting probabilities.

====
+ It is a Markov chain because the next state (list) depends only on the current state (and the element chosen) and not any previous states.

+ For $n=3$, the transition matrix $bold(P)$ is

  #figure(
  table(
    columns: 7,
    stroke: none,
    $X_n without X_(n+1)$, table.hline(), table.vline(),
              [*123*], [*132*], [*213*], [*231*], [*312*], [*321*],
    [*123*],  $P_1$,   $0$,     $P_2$,   $0$,     $P_3$,   $0$,
    [*132*],  $0$,     $P_1$,   $P_2$,   $0$,     $P_3$,   $0$,
    [*213*],  $P_1$,   $0$,     $P_2$,   $0$,     $0$,     $P_3$,
    [*231*],  $P_1$,   $0$,     $0$,     $P_2$,   $0$,     $P_3$,
    [*312*],  $0$,     $P_1$,   $0$,     $P_2$,   $P_3$,   $0$,
    [*321*],  $0$,     $P_1$,   $0$,     $P_2$,   $0$,     $P_3$)  
  )

  On the other hand $pi(i_1,i_2,i_3) = (P_(i_1) P_(i_2))\/(1 - P_(i_1))$. Therefore
  $
    bold(pi) dot bold(P) &= mat(
      (P_1 P_2)/(1 - P_1), 
      (P_1 P_3)/(1 - P_1),
      (P_2 P_1)/(1 - P_2),
      (P_2 P_3)/(1 - P_2),
      (P_3 P_1)/(1 - P_3),
      (P_3 P_2)/(1 - P_3)) dot mat(
        P_1, 0,   P_2,  0,  P_3, 0;
        0,   P_1, P_2,  0,  P_3, 0;
        P_1, 0,   P_2,  0,  0,   P_3;
        P_1, 0,   0,    P_2,0,   P_3;
        0,   P_1, 0,    P_2,P_3, 0;
        0,   P_1, 0,    P_2,0,   P_3) \
    &= mat(
      (P_1 P_2)/(1 - P_1), 
      (P_1 P_3)/(1 - P_1),
      (P_2 P_1)/(1 - P_2),
      (P_2 P_3)/(1 - P_2),
      (P_3 P_1)/(1 - P_3),
      (P_3 P_2)/(1 - P_3)) \
    &= bold(pi)
  $

  So $bold(pi)$ is indeed the limiting probabilities.


=== 4.44
Suppose that a population consists of a fixed number, say, $m$, of genes in any generation. Each gene is one of two possible genetic types. If exactly $i$ (of the $m$) genes of any generation are of type 1, then the next generation will have $j$ type 1 (and $m-j$ type 2) genes with probability
$
  binom(m,j) (i/m)^j ((m-i)/m)^(m-j), quad j=0,1, ... m
$

Let $X_n$ denote the number of type 1 genes in the #th[n] generation, and assume that $X_0 = i$.

+ Find $EE[X_n]$.

+ What is the probability that eventually all the genes will be type 1?

====
+ Given $X_n = k$, $X_(n+1) tilde "Bin"(m, k\/m)$,
  $
    EE[X_n | X_(n-1) = i] = m dot i/m = i = X_(n-1)
  $
  Therefore
  $
    EE[X_n] = EE[X_(n-1)] = dots.c = EE[X_0] = i
  $

+ Eventually all the gnenes will be either type 1 or type 2, for these are the absorbing states. Ans so starting from state $i$,
  $
    EE[X_oo] &= Pr{"eventually all type 1"} dot m + Pr{"eventually all type 2"} dot 0 \
    &= m Pr{"eventually all type 1"}
  $
  On the other hand $EE[X_oo] = i$, so $Pr{"eventually all type 1"} = i\/m$.

=== 4.45
Consider an irreducible finite Markov chain with states $0,1,...,N$.

+ Starting in state $i$, what is the probability the process will ever visit state $j$? Explain!

+ Let $x_i = Pr{"visit state" N "before state" 0 | "start in" i}$. Compute a set of linear equations that the $x_i$ satisfy, $i = 0,1,...,N$.

+ If $sum_j j thin P_(i j) = i$ for $i = 1,...,N - 1$, show that $x_i = i\/N$ is a solution to the equations in part (b).

====
+ An irreducible, finite Markov chain is recurrent, and any two states communicate. So the probability of $j$ reachable from $i$ is $1$.

+ Immediately, $x_0 = 0$ and $x_N = 1$. For the rest, condition on $x_i$'s forward neighbors.
  $
    x_i = sum^N_(j=1) P_(i,j) x_j, thick i = 1, 2, ..., N-1
  $

+ Substituting $x_j = j\/N$:
  $
    sum^N_(j=1) P_(i,j) x_j &= sum^N_(j=1) P_(i,j) j/N \
    &=1/N sum^N_(j=0) j thin P_(i,j) \
    &= i/N \
    &= x_i quad "for" i=1,2,..., N-1
  $
  But $i\/N$ also satisfies $x_0 = 0$ and $x_N = 1$, so $x_i = i\/N$ is a solution to the equations in part (b).

=== 4.46
An individual possesses $r$ umbrellas that he employs in going from his home to office, and vice versa. If he is at home (the office) at the beginning (end) of a day and it is raining, then he will take an umbrella with him to the office (home), provided there is one to be taken. If it is not raining, then he never takes an umbrella. Assume that, independent of the past, it rains at the beginning (end) of a day with probability $p$.

+ Define a Markov chain with $r + 1$ states, which will help us to determine the proportion of time that our man gets wet. (_Note_: He gets wet if it is raining, and all umbrellas are at his other location.)

+ Show that the limiting probabilities are given by
  $
    pi_i = cases(
      q\/(r+q) quad "if" i = 0,
      1\/(r+q) quad "if" i = 1\,2\,...\,r
    )
  $
  where $q = 1-p$.

+ What fraction of time does our man get wet?

+ When $r = 3$, what value of $p$ maximizes the fraction of time he gets wet?

====
+ Define a Markov chain with states ${i, i = 0, 1, ..., r}$ as the number of umbrellas at the individual's disposal at either location (home or office). The transition matrix is (zeros not shown)
  #grid(
    columns: 2,
    align: center + horizon,
    table(
      columns: 7,
      stroke: none,
      $X_n without X_(n+1)$, table.hline(), table.vline(),
            $0$, $1$, $2$, $dots.c$, $r-1$, $r$,
      $0$,  $$,  $$,  $$,  $dots.c$, $$,    $1$,
      $1$,  $$,  $$,  $$,  $dots.c$, $q$,   $p$,
      $2$,  $$,  $$,  $$,  $dots.c$, $p$,   $$,
      $dots.v$,  $dots.v$, $dots.v$, $dots.v$, $dots.down$, $dots.v$, $dots.v$,
      $r-1$,$$,  $q$, $p$, $dots.c$, $$,    $$,
      $r$,  $q$, $p$, $$,  $dots.c$, $$,    $$),
      $ quad "or" quad
      P_(i,j) = cases(
        1 quad & (i,j) = (0,r),
        q quad & i + j = r,
        p quad & i + j = r+1,
        0 quad &"otherwise"
      ) $
  )

+ It is easy to check that $bold(pi) dot bold(P) = bold(pi)$.

+ $display(p thin pi_0 = (p thin q)/(r+q))$.

+ $display(op("argmax", limits: #true)_p (p(1-p))/(3+1-p)) = 4 - 2 sqrt(3) approx 0.5359, thick "maximum" = 7 - 4 sqrt(3) approx 0.0718$.

=== 4.47
Let ${X_n,n >= 0}$ denote an ergodic Markov chain with limiting probabilities $pi_i$. Define the process ${Y_n,n >= 1}$ by $Y_n = (X_(n-1),X_n)$. That is, $Y_n$ keeps track of the last two states of the original chain. Is ${Y_n,n >= 1}$ a Markov chain? If so, determine its transition probabilities and find $ lim_(n -> oo) Pr{Y_n = (i,j)} $

====
${Y_n,n >= 1}$ is a Markov chain because $Y_(n+1)$ depends only on $Y_n$ through the transition probabilities
$
  P_(i j, k l) = cases(
    P_(j l) quad &j=k,
    0 quad &"otherwise"
  ) 
$
where $P_(j l)$ are the transition probabilities of ${X_n}$.

The $lim_(n -> oo) Pr{Y_n = (i,j)}$ are the long-run proportions of ${Y_n}$, or simply $pi_(i j)$. They can be derived by noting that the sequence $(i, j)$ is accomplished whenever the ${X_n}$ chain arrives at $i$ (with probability $pi_i$) and then goes to $j$ (with conditional probability $P_(i j)$). So
$
  pi_(i j) = pi_i P_(i j)
$


=== 4.48
Consider a Markov chain in steady state. Say that a $k$ length run of zeroes ends at time $m$ if
$
  X_(m-k-1) != 0, quad X_(m-k) = X_(m-k+1) = dots.c = X_(m-1) = 0, quad X_m != 0
$
Show that the probability of this event is $pi_0 P^(k-1)_(0,0) (1 - P_(0,0))^2$, where $pi_0$ is the limiting probability of state $0$.

====
First consider the probability $P$ of a $>=k$ run that ends at time $m$
$
  P = pi_0 P^(k-1)_(0,0) (1-P_(0,0))
$

An exact $k$ run is $P$ times the proportion of all $i -> 0$ contributions ($i>0$) among all transitions to $0$, which is $(sum_(i>0) pi_i P_(i,0))\/(sum_i pi_i P_(i,0))$. But $sum_i pi_i P_(i,0) = pi_0$, so

$
  &P thick (sum_(i>0) pi_i P_(0,0))/(sum_i pi_i P_(0,0)) \
  = &P thick (pi_0 - pi_0 P_(0,0)) / pi_0 \
  = &pi_0 P^(k-1)_(0,0) (1 - P_(0,0))^2
$

=== 4.49
Consider a Markov chain with states $1,2,3$ having transition probability matrix
$
  mat(
    0.5, 0.3,0.2;
    0, 0.4, 0.6;
    0.8, 0, 0.2)
$

1. If the chain is currently in state $1$, find the probability that after two transitions it will be in state $2$.

2. Suppose you receive a reward $r(i) = i^2$ whenever the Markov chain is in state $i, i = 1,2,3$. Find your long run average reward per unit time.

Let $N_i$ denote the number of transitions, starting in state $i$, until the Markov chain enters state $3$.

3. Find $EE[N_1]$.

+ Find $Pr{N_1 <= 4}$.

+ Find $Pr{N_1 = 4}$.

====
+ $P^2_(1,2) = 0.27$

+ $display(sum^3_(i=1) i^2 pi_i = 69/17 approx 4.059)$

+ Let $E_i = EE[N_i]$ and solve the system of equations
  $
    E_1 &= 1 + 0.5 E_1 + 0.3 E_2 \
    E_2 &= 1 + 0.4 E_2 \
    E_3 &= 1 + 0.8 E_1
  $
  to get $E_1 = 3, thick E_2 = 5\/3, thick E_3 = 17\/5$.

+ Make state ➂ absorbing, then consider the paths from ➀ to ➂ in exactly 4 steps, and realize that these correspond to the original paths, also from ➀ to ➂, in _no more_ than 4 steps.

  #grid(
    columns: (auto, 1fr, auto, auto),
    align: center + horizon,
    gutter: 1em,
    figure(diagram(
      node-stroke: 1.5pt,
      edge-stroke: .7pt,
      node-shape: circle,
      node((0,0), $1$, name: <1>), 
      edge("->"),
      edge(<1>, "->", bend: 320deg, loop-angle: 0deg),
      edge(<3>, "->", bend: 30deg),
      node((1, 0), $2$, name: <2>),
      edge("->"), 
      edge(<2>, "->", bend: 320deg, loop-angle: 180deg),
      node((1,1), $3$, name: <3>),
      edge(<3>, "->", bend: 320deg),
      edge(<1>, "->", bend: 30deg)),
      caption:[original chain]
    ),
    $=>$,
    figure(diagram(
      node-stroke: 1.5pt,
      edge-stroke: .7pt,
      node-shape: circle,
      node((0,0), $1$, name: <1>), 
      edge("->"),
      edge(<1>, "->", bend: 320deg, loop-angle: 0deg),
      edge(<3>, "->"),
      node((1, 0), $2$, name: <2>),
      edge("->"), 
      edge(<2>, "->", bend: 320deg, loop-angle: 180deg),
      node((1,1), $3$, name: <3>),
      edge(<3>, "->", bend: 320deg)),
      caption: [state $3$ made absorbing]
    ),
    $
      bold(P) = mat(
        0.5, 0.3,0.2;
        0, 0.4, 0.6;
        0, 0, 1)
    $
)

  Therefore
  $
    Pr{N_1 <= 4} &= P^4_(1,3) thick "(of the transformed chain)" \
      &= 0.8268
  $

+ $Pr{N_1 = 4} &= P^4_(1,3) - P^3_(1,3) = 0.1348$.

  To verify, note in the original chain there are 4 paths going from ➀ to ➂ in exactly 4 step:

  - $Pr{➀➀➀➀➂} = 0.5^3 times 0.2 = 0.025$
  - $Pr{➀➀➀➁➂} = 0.5^2 times 0.3 times 0.6 = 0.045$
  - $Pr{➀➀➁➁➂} = 0.5 times 0.3 times 0.4 times 0.6 = 0.036$
  - $Pr{➀➁➁➁➂} = 0.3 times 0.4^2 times 0.6 = 0.0288$

  These probabilities indeed add up to $0.1348$.
  

=== 4.50
A Markov chain with states $1,...,6$ has transition probability matrix
$ 
  mat(
    0.2, 0.4, 0, 0.3, 0, 0.1;
    0.1, 0.3, 0, 0.4, 0, 0.2;
    0, 0, 0.3, 0.7, 0, 0;
    0, 0, 0.6, 0.4, 0, 0;
    0, 0, 0, 0, 0.5, 0.5;
    0, 0, 0, 0, 0.2,0.8)
$

+ Give the classes and tell which are recurrent and which are transient.

+ Find $lim_(n->oo) P^n_(1,2)$.

+ Find $lim_(n->oo) P^n_(5,6)$.

+ Find $lim_(n->oo) P^n_(1,3)$.

====
+ Reading off the transition matrix, there are 3 cliques: ${1,2}$, ${3,4}$, and ${5,6}$, with ${1,2}$ being drained to state $4$ and $6$. So class ${1,2}$ is transient and classes ${3,4}$ and ${5,6}$ are recurrent.

+ ${1,2}$ is transient so $lim_(n->oo) P^n_(1,2) = 0$.

+ ${5,6}$ is recurrent and aperiodic. So just solve the limiting equations locally for class ${5,6}$
  $
    mat(pi_5,pi_6) mat(.5,.5;.2,.8) = mat(pi_5,pi_6)
  $
  to get $pi_5 = 2\/7$ and $pi_6 = 5\/7$. And $lim_(n->oo) P^n_(5,6) = pi_6 = 5\/7$.

+ First calculate $p_i$ ($i = 1,2$) which is the probability  that starting from state $i$, the chain will finally end up in the communication class ${3,4}$. Then $P^oo_(1,3)$ is $p_1$ redistributed to state $3$ according to the long-run proportions of that class.

  By the first 2 rows of the transition matrix we can write
  $
    p_1 &= .2 p_1 + .4 p_2 + .3 \
    p_2 &= .1 p_1 + .3 p_2 + .4  
  $
  to get $p_1 = 37\/52$ and $p_2 = 35\/52$.

  On the other hand 
  $ 
    pi mat(.3,.7;.6,.4) = mat(6\/13, 7\/13)
  $
  hence $lim_(n->oo) P^n_(1,3) = 37\/52 dot 6\/13 = 111\/338 approx 0.328$.


=== 4.51
In Example 4.3, Gary is in a cheerful mood today. Find the expected number of days until he has been glum for three consecutive days.

====
Recall that Gary's mood swings were
#figure(
  table(
    columns: 4,
    stroke: none,
    $X_n without X_(n+1)$, table.vline(), table.hline(), 
            [*C*], [*S*], [*G*],
    [*C*],  $.5$,  $.4$,  $.1$,
    [*S*],  $.3$,  $.4$,  $.3$,
    [*G*],  $.2$,  $.3$,  $.5$,),
  caption: [C=cheerful, S=so so, G=glum]
)

Let $x_"mood"$ equal the expected number of days until Gary has been glum for 3 consecutive days, starting from a "mood" day today. By conditioning on the next day's mood, we have a system of equations:

$
  x_C &= 1 + .5 x_C + .4 x_S + .1 x_G \
  x_S &= 1 + .3 x_C + .4 x_S + .3 x_G \
  x_G &= 1 + .2 x_C + .3 x_S + .5 x_(G G) \
  x_(G G) &= 1 + .2 x_C + .3 x_S
$

where $x_(G G)$ is starting from 2 consecutive glum days already. The answer is $x_C = 236\/9 approx 26.22$ days.

=== 4.52
A taxi driver provides service in two zones of a city. Fares picked up in zone $A$ will have destinations in zone $A$ with probability $0.6$ or in zone $B$ with probability $0.4$. Fares picked up in zone $B$ will have destinations in zone $A$ with probability $0.3$ or in zone $B$ with probability $0.7$. The driver's expected profit for a trip entirely in zone $A$ is $6$; for a trip entirely in zone $B$ is $8$; and for a trip that involves both zones is $12$. Find the taxi driver's average profit per trip.

====
Assuming new fares are always picked up in the same zone where the last fare ended, a taxi driver's pick-up zone is a Markov chain with stationary distribution
$
  pi mat(.6,.4;.3,.7) = mat(3\/7,4\/7)
$

Hence
$
  EE["profit"] &= mat(3\/7, 4\/7) dot 
  vec(EE["profit" | "pick up in" A], EE["profit" | "pick up in" B]) \
  &= mat(3\/7, 4\/7) dot vec(
    .6 times 6 + .4 times 12,
    .3 times 12 + .7 times 8
  ) \
  &= 62/7
$


=== 4.53
Find the average premium received per policyholder of the insurance company of Example 4.29 if $lambda = 1\/4$ for one-third of its clients, and $lambda = 1\/2$ for two-thirds of its clients.

====
Recall that the Bonus Malus system was
#figure(
  table(
    columns:6,
    stroke: none,
    table.hline(),
    [],[],table.cell(colspan:4, [*Next state if*]),
    table.hline(),
    [*State*], table.vline(), [*Annual Premium*], table.vline(), [*0 claims*], [*1 claims*], [*2 claims*], [*$>=$ 3 claims*],
    table.hline(),
    $1$, $200$, $1$, $2$, $3$, $4$,
    $2$, $250$, $1$, $3$, $4$, $4$,
    $3$, $400$, $2$, $4$, $4$, $4$,
    $4$, $600$, $3$, $4$, $4$, $4$,
    table.hline()
  )
)
leading to the transition matrix
$
  bold(P) = mat(align:#left,
    a_0, a_1, a_2, 1 - a_0 - a_1 - a_2;
    a_0, 0, a_1, 1 - a_0 - a_1;
    0, a_0, 0, 1 - a_0;
    0, 0, a_0, 1 - a_0)
  quad "where" a_k = e^(-lambda) lambda^k\/k!
$

The average premium as a function of $lambda$ is therefore
$
  f(lambda) = pi(bold(P)) dot vec(200,250,400,600) 
  = 600 - (100 (1 + e^lambda (3 + 4 e^lambda) - 4 lambda))/(2 e^(3 lambda) - 4 e^lambda lambda - lambda^2)
$

Hence the average premium for different $lambda$'s is
$
  1/3 f(1/4) + 2/3 f(1/2) approx 296.98
$

=== 4.54
Consider the Ehrenfest urn model in which $M$ molecules are distributed between two urns, and at each time point one of the molecules is chosen at random and is then removed from its urn and placed in the other one. Let $X_n$ denote the number of molecules in urn 1 after the #th[n] switch and let $mu_n = EE[X_n]$. Show that

+ $display(mu_(n+1) = 1 + (1 - 2/M) mu_n)$.

+ Use (a) to prove that 
  $
    mu_n = M/2 + ((M - 2)/M)^n (EE[X_0] - M/2)    
  $

====
+ After the #th[(n+1)] switch,
  $
    X_(n+1) = cases(
      X_n - 1 quad& "with probability" X_n\/M,
      X_n + 1 quad& "with probability" 1-X_n\/M,
    )
  $
  Hence
  $
    EE[X_(n+1)] &= X_n/M thin EE[X_n - 1] + (1-X_n/M) thin EE[X_n + 1] \
    &= EE[X_n] + 1 - (2X_n)/M
  $

  Take expectation again:
  $
    EE[X_(n+1)] &= EE[X_n] + 1 - 2/M thin EE[X_n]\
    &= 1 + (1-2/M)EE[X_n]
  $

+ By (a), we have $mu_n = 1 + (1-2\/M) mu_(n-1)$. Rearranging,
  $
    mu_n - M/2 &= (1-2/M)(mu_(n-1) - M/2)\
    &= (1-2/M)^n (mu_0 - M/2)
  $
  which is equivalent to the result.

=== 4.55
Consider a population of individuals each of whom possesses two genes that can be either type $A$ or type $a$. Suppose that in outward appearance type $A$ is dominant and type $a$ is recessive. (That is, an individual will have only the outward characteristics of the recessive gene if its pair is $a a$.) Suppose that the population has stabilized, and the percentages of individuals having respective gene pairs $A A$, $a a$, and $A a$ are $p$,$q$, and $r$. Call an individual dominant or recessive depending on the outward characteristics it exhibits. Let $S_(11)$ denote the probability that an offspring of two dominant parents will be recessive; and let $S_(10)$ denote the probability that the offspring of one dominant and one recessive parent will be recessive. Compute $S_(11)$ and $S_(10)$ to show that $S_(11) = S_(10)$. (The quantities $S_(10)$ and $S_(11)$ are known in the genetics literature as Snyder’s ratios.)

====
TODO

=== 4.56
Suppose that on each play of the game a gambler either wins 1 with probability $p$ or loses 1 with probability $1 - p$. The gambler continues betting until she or he is either up $n$ or down $m$. What is the probability that the gambler quits a winner?

====
The problem is equivalent to the Gambler's Ruin problem starting with $m$ and quits at $m+n$ and
$
  Pr{"quits a winner"} &= cases(
    display((1-(q\/p)^m)/(1-(q\/p)^(m+n))) quad &"if" p != 1/2,
    display(m/(m+n)) quad &"if" p = 1/2
  )
$

=== 4.57
A particle moves among $n + 1$ vertices that are situated on a circle in the following manner. At each step it moves one step either in the clockwise direction with probability $p$ or the counterclockwise direction with probability $q = 1 - p$. Starting at a specified state, call it state $0$, let $T$ be the time of the first return to state $0$. Find the probability that all states have been visited by
time $T$. 

#hint[Condition on the initial transition and then use results from the gambler's ruin problem.]

====
If the first step is clockwise (with probability $p$), then the rest is equivalent to the gambler'r ruin problem starting with $1$ to reach $n+1$. The same can be said of the counterclockwise case.

#figure(diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    node-shape: circle,
    $ 
      0
      edge(->, p, label-side: #center, bend: #40deg)
      edge(<-, q, label-side: #center, bend: #(-40deg))
      &1
      edge("..")
      &n
      edge(->)
      &0'
    $),
    caption: [Equivalent gambler's ruin problem]
)

Therefore
$
  Pr{"all states visited by" T} &= p dot  (1-q/p)/(1-(q/p)^(n+1)) + q dot  (1-p/q)/(1-(p/q)^(n+1))\
  &= cases(
    display((p - q) (q/(p (p/q)^n - q) + p/(p - q (q/p)^n))) quad& p != 1/2,
    display(1/(n+1)) quad& p=1/2

  )
$

=== 4.58
In the gambler's ruin problem of Section 4.5.1, suppose the gambler's fortune is presently $i$, and suppose that we know that the gambler's fortune will eventually reach $N$ (before it goes to $0$). Given this information, show that the probability he wins the next gamble is

$ 
  cases(
    display((p[1 - (q\/p)^(i+1)])/(1 - (q\/p)^i)) quad& "if" p != 1/2,
    display((i+1)/(2i)) quad& "if" p = 1)
$

#hint[
  The probability we want is
  $
    &Pr{X_(n+1) = i + 1 | X_n = i, lim_(m -> oo) X_m = N} \
  = &Pr{X_(n+1) = i + 1, lim_m X_m = N | X_n = i} / Pr{lim_m X_m = N | X_n = i}
  $
]

=== 4.59
For the gambler's ruin model of Section 4.5.1, let $M_i$ denote the mean number of games that must be played until the gambler either goes broke or reaches a fortune of $N$, given that he starts with $i$,$i = 0,1,...,N$. Show that $M_i$ satisfies

$
  M_0 &= M_N = 0;\
  M_i &= 1 + p M_(i+1) + q M_(i-1), quad i = 1,...,N - 1
$

Solve these equations to obtain

$
  M_i = cases(
    i(N - i) quad& "if" p = 1/2,
    display(i/(q-p) - N / (q-p) thick (1-(q\/p)^i) / (1-(q\/p)^N)) quad& "if" p != 1/2)
$

=== 4.60
The following is the transition probability matrix of a Markov chain with states $1,2,3,4$
$
  P = mat(
    0.4,0.3,0.2,0.1;
    0.2,0.2,0.2,0.4;
    0.25,0.25,0.5,0;
    0.2,0.1,0.4,0.3)
$

If $X_0 = 1$

+ find the probability that state $3$ is entered before state $4$;

+ find the mean number of transitions until either state $3$ or state $4$ is entered.

=== 4.61
Suppose in the gambler's ruin problem that the probability of winning a bet depends on the gambler's present fortune. Specifically, suppose that $α_i$ is the probability that the gambler wins a bet when his or her fortune is $i$. Given that the gambler's initial fortune is $i$, let $P(i)$ denote the probability that the gambler's fortune reaches $N$ before $0$.

+ Derive a formula that relates $P(i)$ to $P(i - 1)$ and $P(i + 1)$.

+ Using the same approach as in the gambler's ruin problem, solve the equation of part (a) for $P(i)$.

+ Suppose that $i$ balls are initially in urn 1 and $N - i$ are in urn 2, and suppose that at each stage one of the $N$ balls is randomly chosen, taken from whichever urn it is in, and placed in the other urn. Find the probability that the first urn becomes empty before the second.


#pagebreak()

= scratch

#figure(diagram(
    node-stroke: 1.5pt,
    edge-stroke: .7pt,
    node-shape: circle,
    node((2,0), [甲丙 \ 丁戊], name: <甲>),
    edge("->", $1\/4$, label-side: center, bend: 50deg),
    edge(<甲>, "->", $3\/4$, label-side: center, bend: -310deg, loop-angle: 0deg),
    node((0, 0), [乙], name: <乙>),
    edge(<甲>, "->", $1$, label-side: center, bend: 50deg)
  ),
  caption: $a_0 = 0, a_1 = 1/4, \
  a_n = 3/4 a_(n-1) + 1/4 (1 + a_(n-2))$
)

