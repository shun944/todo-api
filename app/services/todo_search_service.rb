module TodoSearchService
  def self.build_conditions(params)
    todos_table = Todo.arel_table

    conditions = []
    conditions << todos_table[:user_id].eq(params[:user_id]) if params[:user_id]
    if params[:category]
      # categoryと関連付けた後で検索
      category_master = CategoryMaster.find_by!(category_name: params[:category])
      conditions << todos_table[:category_master_id].eq(category_master.id) if category_master
    end
    # conditions << todos_table[:due_date].lt(params[:due_date]) if params[:due_date]
    if params[:start_date]
      conditions << todos_table[:start_date].lt(params[:start_date][:before]) if params [:start_date][:before]
      conditions << todos_table[:start_date].gt(params[:start_date][:after]) if params [:start_date][:after]
    end
    if params[:due_date]
      conditions << todos_table[:due_date].lt(params[:due_date][:before]) if params [:due_date][:before]
      conditions << todos_table[:due_date].gt(params[:due_date][:after]) if params [:due_date][:after]
    end
    conditions << todos_table[:title].matches("%#{params[:title]}%") if params[:title]
    conditions << todos_table[:description].matches("%#{params[:description]}%") if params[:description]

    conditions
  end
end
