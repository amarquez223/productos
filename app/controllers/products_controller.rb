class ProductsController < ApplicationController
	def index
		@products = Product.all
	end

	def new
	    @product = Product.new
	    @catpro = Catpro.new
	    @categories = Category.all
	  end

	def create
		@product = Product.new(product_params)
		
		# begin_db_transaction()

		if @product.save && create_catpros
			# commit()
	    	redirect_to root_path
	    else
	    	# rollback()
	      	render :new
	    end
	end

	def edit
		@product = Product.find(params[:id])
		@categories = Category.all
		@catpros = Catpro.where('product_id = ' + params[:id])
	end

	def update
		@product = Product.find(params[:id])
		
		# begin_db_transaction()
		
		@product.update(product_params)
		
		@catpros = Catpro.where('product_id = ' + params[:id])
		@catpros.destroy_all
		
		if params.has_key?(:catpro)
			params[:catpro].each_pair do |key|
				Catpro.create(category_id: key, product_id: params[:id])
			end
		end

		# commit()
		
		redirect_to root_path
	end

	def destroy
		product = Product.find(params[:id])
		
		@catpros = Catpro.where('product_id = ' + params[:id])
		@catpros.destroy_all
		

		product.destroy

		redirect_to root_path
	end

	private
	def create_catpros
		@last_product = Product.last
		params[:catpro].each_pair do |key|
			Catpro.create(category_id: key, product_id: @last_product.id)
		end
	end
	
	protected
    def product_params
      params.require(:product).permit(:name, :price)
    end
    
end
