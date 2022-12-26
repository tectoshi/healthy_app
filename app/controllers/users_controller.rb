class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end 
  end

  def show
    @gender = Gender.find(current_user.gender_id).name
    get_nutrients_sum
    week_nutrient
    @nutrient_graph = {カロリー: @calorie/@cal * 100, 
                       タンパク質: @protein/@pro * 100,
                       脂質: @lipid/@lip * 100, 
                       炭水化物: @carbohydrate/@car * 100,
                       糖質: @sugar/@sug * 100,
                       食物繊維: @fiber/@fib * 100}
    # BMI ＝ 体重kg ÷ (身長m)^2
    @bmi = current_user.weight / (current_user.height/100)**2
    # 適正体重 ＝ (身長m)^2 ×22
    @best_w = (current_user.height/100)**2 * 22
    @date = Date.today.strftime('%Y年%m月%d日')
  end

  private
  def user_params
    params.require(:user).permit(:name, :height, :weight, :gender_id, :birth)
  end

  def get_nutrients_sum
    nutrients = Nutrient.where(created_at: this_week).where(user_id: current_user.id)
    @calorie = 0
    @protein = 0
    @lipid = 0
    @carbohydrate = 0
    @sugar = 0
    @fiber = 0
    nutrients.each do |nutrient|
      @calorie += nutrient.calorie
      @protein += nutrient.protein
      @lipid += nutrient.lipid
      @carbohydrate += nutrient.carbohydrate
      @sugar += nutrient.sugar
      @fiber += nutrient.fiber
    end
  end

  def week_nutrient
    birthday = Date.parse("#{current_user.birth}") 
    @age = (Date.today.strftime('%Y%m%d').to_i - birthday.strftime('%Y%m%d').to_i) / 10000
    if current_user.gender_id == 1
      @cal = (13.397 * current_user.weight + 4.799 * current_user.height - 5.677 * @age.to_f + 88.362) * 7 * 1.75
      @pro = 65 * 7
      @lip = 55 * 7
      @car = 310 * 7
      @sug = 330 * 7
      @fib = 21 * 7
    else
      @cal = (9.247 * current_user.weight + 3.098 * current_user.height - 4.33 * @age.to_f + 447.593) * 1.75
      @pro = 50 * 7
      @lip = 45 * 7
      @car = 270 * 7
      @sug = 270 * 7
      @fib = 18 * 7
    end
  end

  def this_week
    today = Date.today
    day_of_the_week = today.wday
    week = ["日","月","火","水","木","金","土"]
    @wday = week[day_of_the_week]
    # 曜日毎に月曜と日曜の日付を取得
    case day_of_the_week
      # 日曜日
      when 0 then
        @from = (today - 6.day).at_beginning_of_day
        @to = today.at_end_of_day
      # 月曜日
      when 1 then
        @from = today.at_beginning_of_day
        @to = (today + 6.day).at_end_of_day
      # 火曜日
      when 2 then
        @from = (today - 1.day).at_beginning_of_day
        @to = (today + 5.day).at_end_of_day
      # 水曜日
      when 3 then
        @from = (today - 2.day).at_beginning_of_day
        @to = (today + 4.day).at_end_of_day
      # 木曜日
      when 4 then
        @from = (today - 3.day).at_beginning_of_day
        @to = (today + 3.day).at_end_of_day
      # 金曜日
      when 5 then
        @from = (today - 4.day).at_beginning_of_day
        @to = (today + 2.day).at_end_of_day
      # 土曜日
      when 6 then
        @from = (today - 5.day).at_beginning_of_day
        @to = (today + 1.day).at_end_of_day
    end
    # 返り値をfrom..toの形に
    @from..@to
  end
  

end

