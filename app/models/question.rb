class Question < ApplicationRecord

  # this sets up one-to-many association between the question and the answer
  # in this case a question has many answers (note that to set a one-to-many
  # association you will have to pluralize `answer` - Rails convention)
  # we will have many handy method to helps us query associated records.
  # for instance we can do:
  # q = Question.last
  # answers = q.answers
  # the line above will fetch all the answers associated with question: q
  # It's highly recommended that you add the `dependent` option to the
  # association which tells Rails what to do when you delete a question that
  # has answers associated with it, the most popular options are:
  # destroy: which will delete all associated answers before deleting the
  #          question
  # nullify: which will update all the `question_id` fields on the associated
  #          answers to become `NULL` before deleting the question
  # dependent: :nullify  to make null on  delete
  has_many :answers, -> { order(created_at: :desc) }, dependent: :destroy
  belongs_to :user
  # validates :title, presence: { message: 'must be given!' }
  validates(:title, { presence: { message: 'must be given!' },
                      uniqueness: true })
  validates :body, presence: true, length: { minimum: 3 }
  validates :view_count, presence: true,
                         numericality: { greater_than_or_equal_to: 0 }

  # when use `validates` with an `s` then Rails expect one of the Rails built-in
  # validation options such as: :presense, :uniqueness, :numericality..etc

  # if you want to write a custom validation method then you will need to use
  # `validate` (no s)
  validate :no_monkey

  # this callback runs after a question is successfully created
  after_save(:alert_us)

  # the following is a callback that will run the method set_view_count
  # before any validation is run on the model
  after_initialize(:set_view_count)

  # define a class method by adding self. in front of a method name
  # This method will be callable on the class itself (i.e. Question.search("thing"))
  def self.search(query)
    where("title ILIKE ? or body ILIKE ?", "%#{query}%", "%#{query}%")
  end

  private

  def set_view_count
    self.view_count ||= 0
  end

  def alert_us
    puts "🚨🚨🚨🚨🚨🚨🚨🚨"
  end

  def no_monkey
    if title.present? && title.downcase.include?('monkey')
      errors.add(:title, 'No monkeys please!')
    end
  end

end
