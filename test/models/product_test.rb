require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products # Ruby does this automatically, but we can override/control
  # test "the truth" do
  #   assert true
  # end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    
    product = Product.new(
      title: "My Book Title",
      description: "My Book Description",
      image_url: "mybookimage.png"
    )
    
    product.price = -1
    assert product.invalid?

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?

  end

  def new_product(image_url)
    Product.new(title: "My Book Title", description: "My Book Description", price: 1, image_url: image_url)
  end

  test "image url" do

    # good image urls
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.GIF FRED.PNG Fred.Jpg http://a.b.c.d/x/y/z/fred.gif }

    # bad image urls
    bad = %w{ fred.doc }

    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} shouldn't be invalid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} shouldn't be valid"
    end

  end

  test "product is not valid without a unique title" do 
    product = Product.new(title: products(:ruby).title, description: "My Book Description", price: 1, image_url: "fred.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

end
