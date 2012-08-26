# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
#
# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.acronym 'RESTful'
# end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular(/(x|ch|ss|sh)es$/i, '\1e') # pamplemousses => pamplemousse
  inflect.singular(/([a-z])x$/i, '\1') # maquereaux => maquereau
  inflect.irregular('noix', 'noix')
  inflect.irregular('choux', 'choux')


end