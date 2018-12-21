# React Native + IGListKit = UICollectionViews with React-rendered cells at 60fps

:warning: Work in progress... :warning:

## 🤔 What is this thing?

This demonstrates how we're using [IGListKit](https://github.com/instagram/IGListKit) in our React Native app at [Clubhouse](https://clubhouse.io).

This project rips out the interesting bits of combining these two technologies, sans our domain-/product-specific bits.

We opened the source of this project up to ask the IGListKit community some questions, file an Apple TSI for some drag-and-drop bugs we've seen, and generally show the iOS and React Native communities how to make great platform-specfic experiences with these technologies!

## 😐 But... why?

We wanted to build an experience for our Stories view that allowed users to drag-and-drop Stories between columns, within a column, and even outside of the app, into other apps. To do this, we would need to implement some new APIs introduced in iOS 11. While projects like [Matt Oakes' `react-native-ios-drag-drop`](https://github.com/matt-oakes/react-native-ios-drag-drop) exist to bind to `UIDragItems` from JS-land, we wanted to go even further and use a `UICollectionView` to allow our users to drag-and-drop across iOS.

Another goal of ours was to keep as much of our view layer in React Native land as possible, in order to prevent duplicating code or features in ObjC/Swift and JavaScript. We didn't want to create a `StoryView.swift` when we were already using a `<StoryView />` throughout our app in many places.

### 🤨 Okay, but why IGListKit and not just `UICollectionView`?

We spent some time trying to do this without the help of IGListKit, but quickly realized that there are a lot of niceities that IGListKit would bring to us here! A few main ones were:

#### Simplified layout of cells, as they relate to their props (including caching of cell sizes)

IGListKit shares some paradigms with React's render model: Given the same data in, I'll give you a view out that matches your expectations

#### Decoupling of `UICollectionView` concepts from complex view layouts

It was really easy to create a nested `UICollectionView` inside a `UICollectionView` to give us mutiple scrollable columns to drag items to the right spot. A single UICollectionView and layout wouldn't be able to give us this, and ballooning this out into multiple `UICollectionView`s without IGListKit made our data flow hard to manage

#### A nice abstraction around the layout we wanted, without coupling our data model

We could create abstract concepts, like `Section` and `Item` in IGListKit-land, and then populate the data needed to render our product-specific views on the native side, while our JS abstraction could handle all the bits it needed to know about.

### 😖 IGListKit Caveats

This wasn't without it's caveats, however. A few pain points we ran into with IGListKit were:

#### The documentation isn't completely straight-forward

Since we didn't have all our data modeled nicely in Swift like the IGListKit docs kind of recommend, we had to dive in and figure out what models to draw up to get to a place we liked. Our first attempt was riddled with bugs related to a new set of data coming in from JS, that would do things like reset scroll state, or crash on pagination due to an invalid number of insertions/deletions. We set out to try to understand how [`IGListBindingSectionController`](https://instagram.github.io/IGListKit/Classes/IGListBindingSectionController.html) could help us, since we knew it could help us [do the diffing along with inserts and deletes](https://github.com/Instagram/IGListKit/blob/4387a488e80e1dcb7677c18a2b4f5768e9f0dab7/Source/IGListBindingSectionController.m#L52-L90)

However, even now, with this demo project done, I'm not entirely sure of the repercussions of using new value types vs new reference types for `ListDiffable` implementations, or what the cost of creating new view models during pagination is instead of mutating an existing view model. I'd love some more clarity here (PRs gladly accepted)!

Another hurdle we ran into is understanding when and were to create adapters, and their relationships with view models and even `UIViewController` itself.

- https://github.com/eliperkins/react-native-listkit/blob/3ff76521352d5acfffdf59b47ff24d05c114ed02/ios/View%20Models/ColumnViewModel.swift#L45
- https://github.com/eliperkins/react-native-listkit/blob/3ff76521352d5acfffdf59b47ff24d05c114ed02/ios/View%20Models/ColumnViewModel.swift#L26

## TODO

This is still a work-in-progress, as we still product code into this sample project

- [ ] Add drag-and-drop to reorder functionality
- [ ] Dynamic cell heights given a React Native view's intrinsic content size
- [ ] Proper loading states
- [ ] Turn into a proper React Native node_module, consumable via `react-native link` (I see you @neilkimmett)
- [ ] [Fabric for UICollectionViewCells](https://github.com/facebook/react-native/blob/f88ce826275bf19ba772fc23ab22d1c0bc47be7d/React/Base/Surface/RCTSurface.h#L44-L46)?!
