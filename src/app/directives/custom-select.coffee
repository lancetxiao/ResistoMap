app.directive 'customSelect', ($document, $timeout) ->
  restrict: 'E'
  replace: true
  templateUrl: 'templates/directives/custom-select.html'
  scope:
    key: '='
    dataset: '='
    multi: '='
    toggleFormat: '='
    disabled: '='
    filterValues: '='
  link: ($scope, $element, $attrs) ->
    $scope.isListShown = true

    $scope.toggleList = ->
      return if $scope.disabled

      $scope.isListShown = !$scope.isListShown

      if $scope.isListShown
        $document.bind 'click', clickHandler
      else
        $document.unbind 'click', clickHandler
      return

    $scope.isItemSelected = (item) ->
      if $scope.multi
        index = _.indexOf _.pluck($scope.filterValues[$scope.key], 'title'), item.title
        index isnt -1
      else
        $scope.filterValues[$scope.key].title is item.title

    $scope.selectItem = (item) ->
      if $scope.multi
        index = _.indexOf _.pluck($scope.filterValues[$scope.key], 'title'), item.title

        if index isnt -1
          $scope.filterValues[$scope.key].splice index, 1
        else
          $scope.filterValues[$scope.key].push item
      else
        $scope.filterValues[$scope.key] = item
        $scope.isListShown = false
      return

    clickHandler = (event) ->
      return if $element.find(event.target).length

      $scope.isListShown = false
      $scope.$apply()
      $document.unbind 'click', clickHandler
      return

    $timeout ->
      $element.find('.custom-select__toggle').innerWidth $element.find('.custom-select__dropdown')[0].getBoundingClientRect().width
      $scope.isListShown = false
      return

    $scope.$watch 'disabled', ->
      $scope.filterValues[$scope.key] = $scope.dataset[0]
      return

    return
