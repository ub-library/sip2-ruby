module Sip2
  module Meta
    module FieldsConstants
      project_dir = __dir__ + "/../../.."

      fields_with_code, fields_without_code = %w[with without]
        .map { |set|
          File
            .readlines("#{project_dir}/doc/sip2_fields_#{set}_code.txt")
            .map(&:chomp)
        }

      FIELD_HAS_CODE = {}

      fields_with_code.each do |field|
        FIELD_HAS_CODE[field.to_s] = true
      end

      fields_without_code.each do |field|
        FIELD_HAS_CODE[field.to_s] = false
      end

      FIELD_HAS_CODE["items"] = true

    end
  end
end
