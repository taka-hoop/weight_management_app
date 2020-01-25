class GraphsController < ApplicationController
  def index
    # gon.chart_label = ['1/1', '1/2', '1/4', '1/5', '1/6', '1/7']
    # null を nil にしないといけないので注意！jsにデータを渡す時はgon.~ jsはnil
    # gon.chart_data = [60.3, 61.1, 60.8, nil, 60.5, 61.4]
    # 例（代入するデータは後に修正します）
    # gon.weight_records = Graph.all
    gon.weight_records = Graph.chart_data(current_user)
    gon.recorded_dates = current_user.graphs.map(&:date)
  end

  def create
    @graph = current_user.graphs.build(graph_params)
    date = @graph.date.strftime('%Y/%-m/%-d')
    if @graph.save
      flash[:notice] = "#{date}の記録を追加しました"
    else
      flash[:alert] = 'エラーが発生しました'
    end
    redirect_to root_path
  end

  def update
    @graph = current_user.graphs.find_by(date: params[:graph][:date])
    # パラムスグラフデータ　飛んできたデータを探すそれ@graphに入れてる
    date = @graph.date.strftime('%Y/%-m/%-d')
    if @graph.nil?
      flash[:alert] = 'エラーが発生しました'
      # 情報があった場合は更新なかった場合は削除する記述
    elsif params[:_destroy].nil? && @graph.update(graph_params)
      flash[:notice] = "#{date}の記録を修正しました。"
    elsif params[:_destroy].present? && @graph.destroy
      flash[:alert] = "#{date}の記録を削除しました。"
    else
      flash[:alert] = 'エラーが発生しました'
    end
    redirect_to root_path
  end

  private

  def graph_params
    params.require(:graph).permit(:date, :weight)
  end

end
