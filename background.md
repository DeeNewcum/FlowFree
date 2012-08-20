## Permutations

The solution space can be viewed as a grid of arrows.  For example, for a 4x4 board:

<table>
<tr><td>↓<td>→<td>↓<td>←
<tr><td>→<td>←<td>→<td>↑
<tr><td>↓<td>→<td>↑<td>↓
<tr><td>→<td>↑<td>→<td>↑
</table>

Each cell has four possibilities, so the number of permutations is 4^n²:

<table>
<tr><th>n<th>permutations
<tr><td>4<td>4.2×10⁹
<tr><td>5<td>1.2×10¹⁵
<tr><td>6<td>4.7×10²¹
<tr><td>7<td>3.1×10²⁹
<tr><td>8<td>3.4×10³⁸
<tr><td>9<td>5.8×10⁴⁸
</table>

The number of permutations is slightly less than this, for various reasons:

* Corners cells only have two possibilities, and edge cells only have three.
* For each pair of start+end points, only the start-point permutes through all possible directions; once the end-point is reached, you don't travel to another cell.  So the end-point cells aren't counted.
