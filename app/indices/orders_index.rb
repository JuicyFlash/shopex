ThinkingSphinx::Index.define :order, with: :active_record do
  #fields
  indexes products.title, as: :product, sortable: true
  indexes detail.first_name, as: :first_name
  indexes detail.last_name, as: :last_name
end
