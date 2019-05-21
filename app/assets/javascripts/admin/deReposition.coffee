$ ->
  # 参数ID形式为 #id, url为需要更新position的url
  window.deReposition =
    call: (source, url, options=null) ->
      if($(source).length)
        $(source).sortable(
          update: (e, ui) ->
            if(window.confirm('你确定要移动吗？'))
              itemId = ui.item.attr('id')
              prevId = ui.item.prev().attr('id')
              nextId = ui.item.next().attr('id')

              if(options && options.level == 2)
                pathname = window.location.pathname
                level_param = options.level_param
                level_param_id = parseInt(pathname.replace(/[^0-9]+/g, ''))

              $.ajax
                url: url.replace(':id', itemId.split('_').pop()).replace(":#{level_param}", level_param_id)
                type: "POST"
                data:
                  id: itemId
                  level_param: level_param_id
                  prev_id: prevId
                  next_id: nextId
            else
              location.reload();
        );


