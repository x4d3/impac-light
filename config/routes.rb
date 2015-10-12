Rails.application.routes.draw do
  resources :widgets
  root 'welcome#index'
  # Used example from http://apionrails.icalialabs.com/book/chapter_two
  # Api definition
  namespace :api do
    # We are going to list our resources here
    namespace :v1 do
      # We are going to list our resources here
      namespace :accounts do
        resources :assets_summary, :expenses_revenue
        namespace :accounting_values do
          resources :ebitda
        end
      end
    end
  end
end
