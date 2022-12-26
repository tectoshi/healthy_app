class NutrientsController < ApplicationController

  def index
  end

  def new
    @nutrient = Nutrient.new
  end

  def create
    input_nutrient_sum
    # 送られてきたデータの数だけ保存
    @nutrients_status.each do |nutrient|
      nut = Nutrient.create(nutrient)
      #カレンダー表示のため@start_timeがカラムに必要
      #paramsは普通のハッシュと混合では保存できなかった。
      #start_timeはparamsでの保存しかできなかったので、他のデータ保存後にstart_timeだけ上書きするようにしてカバー。
      nut.update(@start_time)
    end
    if Nutrient.where(user_id: current_user.id).present?
      redirect_to user_path(current_user) 
    else
      render :new
    end    
  end

  def show
    
  end


  private

  def input_nutrient_sum
    # 値の受け取り
    food_input = params.require(:nutrient)
                       .permit(:food_id_0, :number_id_0,
                               :food_id_1, :number_id_1,
                               :food_id_2, :number_id_2,
                               :food_id_3, :number_id_3,
                               :food_id_4, :number_id_4,
                               :food_id_5, :number_id_5,
                               :food_id_6, :number_id_6,
                               :food_id_7, :number_id_7,
                               :food_id_8, :number_id_8,
                               :food_id_9, :number_id_9)
                       .merge(user_id: current_user.id)
    # food_idとnumber_idの取り出し＆配列に収納
    input_ids = []
    10.times do |i|
      input_ids << {food_id: food_input[:"food_id_#{i}"], number_id: food_input[:"number_id_#{i}"]}
    end
    # 紐付け用user_id
    @start_time = params.require(:nutrient).permit(:start_time)
    
    user_id = food_input[:user_id]
    # 送られたidを用いて選択された食材と個数をそれぞれ判別
    # また個数から食材ごとの各栄養素の合計を配列に収納
    @nutrients_status = []
    input_ids.each do |input|
      if input[:food_id].to_i != 0 || input[:number_id].to_i != 0
        num = Number.find(input[:number_id]).name
        nutrient = First.find(input[:food_id])
        name = nutrient.name
        calorie = nutrient.calorie * num
        protein = nutrient.protein * num
        lipid = nutrient.lipid * num
        carbohydrate = nutrient.carbohydrate * num
        sugar = nutrient.sugar * num
        fiber = nutrient.fiber * num
        @nutrients_status << {name: name, calorie: calorie, protein: protein, lipid: lipid, carbohydrate: carbohydrate, sugar: sugar, fiber: fiber, number: num, user_id: user_id, start_time: @start_time}
      end
    end
    
  end
  
end
