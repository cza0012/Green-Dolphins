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
end
