#= require active_admin/base
#= require simditor
#= require ./editor
#= require ./homepage
#= require best_in_place
#= require_tree ./admin
#= require chartkick
#= require Chart.bundle
$(document).ready ->
  jQuery(".best_in_place").best_in_place()