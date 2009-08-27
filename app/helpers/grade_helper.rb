# Helper methods for the "My Grades" controller
module GradeHelper

  # Build the table showing the students overall grade for each course
  def my_grades_table
    # Prepare the data
    @school_year.terms.sort!{|a,b| a.end_date <=> b.end_date}

    # Build the header
    body = %{
      <table class="master sortable">
        <thead><tr>
        <th>Course</th>
        <th>Teacher</th>
    }

    # Add the terms to the header
    @school_year.terms.each do |term|
      body << content_tag( :th, term.name)
    end

    body += %{
      </tr></thead>
      <body>
    }

    # Build the body of the table
    @courses.each do |course|
      body += %{
        <tr class="#{cycle('odd','even')}"
          onclick="location.href='#{url_for( :action => "show", :id => course.id )}'" >
          <td>#{course.name}</td>
          <td>#{course.teacher.full_name}</td>
      }

      # Show the grades for each term in this course
      @school_year.terms.each do |term|
        course_term = CourseTerm.find_by_course_id_and_term_id(course.id, term.id)
        grade = course_term.calculate_grade(current_user)

        # Only show grades for course_terms that have assignments and scores
        if grade[:score].round >= 0
          score = "#{grade[:letter]} (#{grade[:score].round}%)"
        end
        body << "<td><a href='/grades/#{course.id}##{term.name}'>#{score}</a></td>"
      end

      body += %{
      </tr>
      }
    end

    # Finish up the table structure
    body += "</body></table>"
    
    return body
  end

  # Build the table showing the students overall grade for each course
  def my_grades_detail_table(course_term)
    # Build the header
    body = %{
      <table class="master sortable">
        <thead><tr>
        <th>Assignment</th>
        <th>Type</th>
        <th>Due Date</th>
        <th>Score</th>
      </tr></thead>
      <body>
    }

    # Build the body of the table
    if course_term.assignments.size < 1
      body += "<tr><td colspan='0'>No assignments found</td></tr>"
    else
      course_term.assignments.sort{|a,b| a.due_date <=> b.due_date}.each do |assignment|
        grade = assignment.calculate_grade(current_user.id)
        score = grade[:letter]
        score += " (#{grade[:score].round}%)" if grade[:score].round >= 0
        body += %{
        <tr class="#{cycle('odd','even')}">
          <td>#{assignment.name}</td>
          <td>#{assignment.assignment_category.name}</td>
          <td>#{assignment.due_date.to_s(:due_date)}</td>
          <td>#{score}</td>

        }

        body += %{
      </tr>
        }
      end
    end

    # Finish up the table structure
    body += "</body></table>"

    return body
  end
end