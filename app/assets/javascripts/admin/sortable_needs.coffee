$ ->
  # 需要排序的
  lists = [
    ['#index_table_cash_games tbody', '/admin/cash_games/:id/reposition'],
    ['#index_table_infos tbody', '/admin/infos/:id/reposition'],
    ['#index_table_homepage_banners tbody', '/admin/homepage_banners/:id/reposition'],
    ['#index_table_cash_queue_members tbody', '/admin/cash_queues/:cash_queue_id/cash_queue_members/:id/reposition', {level: 2, level_param: 'cash_queue_id'}]
  ]

  for list in lists
    deReposition.call(list[0], list[1], list[2])