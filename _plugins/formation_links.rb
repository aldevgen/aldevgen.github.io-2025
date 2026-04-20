module FormationLinks
  class FormationLinkGenerator < Jekyll::Generator
    def generate(site)
      site.collections['formations'].docs.each do |doc|
        path_parts = doc.relative_path.split(File::SEPARATOR)

        if path_parts[0] == '_formations' && path_parts.length >= 3
          filename = path_parts[-1]

          # Extract importance level
          importance = filename[/^(\d+)_/, 1]

          # Extract lesson name (remove leading number, underscore and .md extension)
          course_lesson = filename
            .gsub(/^\d+_/, '')
            .gsub(/\.md$/, '')

          # Store the importance as the order of the page in the collection
          doc.data['importance'] = importance

          # Handle both 2-level (formations/course_name/lesson.md)
          # and 3-level (formations/institute/course_name/lesson.md)
          if path_parts.length == 3
            # 2-level: formations/course_name/lesson.md
            course_name = path_parts[1]
            doc.data['permalink'] = "/formations/#{course_name}/#{course_lesson}/"
          elsif path_parts.length == 4
            # 3-level: formations/institute/course_name/lesson.md
            institute = path_parts[1]
            course_name = path_parts[2]
            doc.data['permalink'] = "/formations/#{institute}/#{course_name}/#{course_lesson}/"
          elsif path_parts.length >= 5
            # 3-level: formations/institute/level/course_name/lesson.md
            institute = path_parts[1]
            level = path_parts[2]
            course_name = path_parts[3]
            doc.data['permalink'] = "/formations/#{institute}/#{level}/#{course_name}/#{course_lesson}/"
          end
        end
      end
    end
  end
end
