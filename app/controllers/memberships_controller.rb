
class MembershipsController < ApplicationController
  def new
    @user = current_user
    @beer_clubs = BeerClub.all.filter { |club| !@user.beer_clubs.include?(club)}
  end

  def create
    @user = current_user
    @membership = Membership.new beer_club_id: params[:beer_club_id]
    @membership.user_id = @user.id
    if @membership.save
      redirect_to @user
    else
      format.html { render :new, status: :unprocessable_entity }
    end
  end

  def destroy

  end
end