# module UidModel
#   def self.find(*args, &block)
#     begin
#       super
#     rescue ActiveRecord::RecordNotFound
#       self.find_by_uid(args[0]) if self.respond_to?(:find_by_uid)
#       # self.find_by_uid(args[0]) if self.attribute_method?(:uid)
#     end
#   end
# end