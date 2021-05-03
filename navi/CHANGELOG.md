# [0.2.2] - 04.05.2021

* Reported route should always be normalized:
  * `./` and `../` segments should be resolved
  * blank segments should be removed
* Allow navigating with `./` (current route) and `../` (goes up one level in the route)
* Add `context.navi.currentRoute`, `context.navi.toRoute`, `context.navi.relativeToRoute`, `context.navi.canPop`
  , `context.navi.maybePop`, `context.navi.pop`
* Fix some minor bugs

# [0.2.1] - 29.04.2021

* Hotfix: remove duplicated routes in history

# [0.2.0] - 25.04.2021

* Move from POC phase to development phase. 0.0.x and 0.1.x are just an experiment. Since 0.2, `Navi` is ready to be
  used in your app. Backward compatibility, performance and stability will be considered. Migration documentation will
  be provided.
* Replace `RouteStack` with `NaviStack` widget with much simpler API
* Add `NaviRouteMixin` to receive notification on new route

NOTE: no backward compatible

# [0.1.2] - 05.04.2021

* Fix bug: stack controller should be notified with the initial state

# [0.1.1] - 03.04.2021

* Fix bug: https://github.com/zenonine/navi/issues/29

# [0.1.0] - 03.04.2021

* Add `RouteStack` widget as replacement of the old `RouteStack` class
* Remove `StackOutlet` widget
* Add architecture documentation
* Add more examples

NOTE: no backward compatible with 0.0.x

# [0.0.6] - 27.03.2021

* Add `InlinePageStack` class
* Add more examples

# [0.0.5] - 26.03.2021

* Update docs

# [0.0.4] - 26.03.2021

* Update docs and examples

# [0.0.3] - 25.03.2021

* Implement declarative API (without routing capability in child and nested stacks)

# [0.0.2] - 07.03.2021

* Reorganize repository structure

# [0.0.1] - 07.03.2021

* Initial build without implementation
