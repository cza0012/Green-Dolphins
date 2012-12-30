module UsersHelper
  def user_role user
    role = 'Student'
    expert = false
    user_roles = user.roles
    user_roles.each do |r|
      if r.name == 'admin'
        return role = 'Admin'
      elsif r.name == 'ta'
        return role = 'TA'
      elsif r.name == 'instructor'
        return role = 'Instructor'
      elsif r.name == 'expert'
        expert = true
      end
    end
    if expert
      role = 'Expert student'
    else
      role
    end
  end
  
  def rank_user( rank, all_user, user )
    if user == current_user
      'info'
    elsif ((all_user*10.0)/100).ceil >= rank
      'success'
    elsif ((all_user*90.0)/100).floor <= rank
      'warning'
    end
  end
end
