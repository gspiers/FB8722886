# Feedback FB8722886

Sample project for Apple Feedback number FB8722886, UICollectionViewCompositionalLayout: Pinned boundary supplementary items disappear when layout contains sections with orthogonal scrolling.

## Details

When using UICollectionView compositional layout I’m trying to pin global headers using `pinToVisibleBounds = true` for boundary items. This does not work as expected when the layout has a section that has `section.orthogonalScrollingBehavior = .continuous`. The global boundary items disappear as you scroll down (see sample project and video).

When not using the orthogonal scrolling the pinned global headers correctly stay on screen while scrolling in the collection view.

The documentation suggest this should work: 
`UICollectionViewCompositionalLayoutConfiguration`

`boundarySupplementaryItems`:
An array of the supplementary items that are associated with the boundary edges of the entire layout, such as global headers and footers.

## Example

[Full resolution video of bug](compositional_bug.mov).

![](compositional_bug.gif)


