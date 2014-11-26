angular.module("ionicApp", ["ionic"])
.factory 'GeoSearchService', ($q, $timeout) ->
  getCurrentPosition: ->
    deferred = $q.defer()
    options =
      maximumAge: 10000
      timeout: 30000
      enableHighAccuracy: false
    applican.geolocation.getCurrentPosition (res) ->
      deferred.resolve(res)
    , (res) ->
      deferred.reject(res)
    , options
    deferred.promise
.factory 'FoursqureService', ($q, $http, $timeout) ->
  getVenues: (lat, lon) ->
    deferred = $q.defer()
    client_id = "FOURSQUARE_CLIENT_KEY"
    secret    = "FOURSQUARE_SECRET_KEY"
    options = 
      timeout: 10000
      headers: {}
      verboseoutput: true
    applican.http.get "https://api.foursquare.com/v2/venues/search?ll=#{lat},#{lon}&client_id=#{client_id}&client_secret=#{secret}&v=20140715&limit=50", options, (res) ->
      res = JSON.parse res
      deferred.resolve(res.response)
    , (res) ->
      console.log res
      deferred.reject(res)
    deferred.promise
.controller "MyCtrl", ($scope, $ionicPopover, GeoSearchService, FoursqureService) ->
  $scope.data = showDelete: false
  $ionicPopover.fromTemplateUrl "my-popover.html",
    scope: $scope
  .then (popover) ->
    $scope.popover = popover
  $scope.openPopover = ($event, item) ->
    console.log $event, item
    console.log $scope.popover
    $scope.item = item
    $scope.popover.show $event
  $scope.closePopover = ->
    $scope.popover.hide()
  $scope.$on "$destroy", ->
    $scope.popover.remove()
  $scope.$on "popover.hidden", ->
  $scope.$on "popover.removed", ->
  $scope.edit = (item) ->
    alert "Edit Item: " + item.id
  $scope.share = (item) ->
    alert "Share Item: " + item.id
  $scope.moveItem = (item, fromIndex, toIndex) ->
    $scope.items.splice fromIndex, 1
    $scope.items.splice toIndex, 0, item
  $scope.onItemDelete = (item) ->
    $scope.items.splice $scope.items.indexOf(item), 1
  GeoSearchService.getCurrentPosition().then (res) ->
    c = res.coords
    FoursqureService.getVenues c.latitude, c.longitude
    .then (res) ->
      $scope.items = []
      console.log res.venues
      angular.forEach res.venues, (venue) ->
        options = title: venue.name
        if venue.categories.length > 0
          icon = venue.categories[0].icon
          options.img = "#{icon.prefix}bg_88#{icon.suffix}"
        options.lat = venue.location.lat
        options.lng = venue.location.lng
        $scope.items.push options
        
