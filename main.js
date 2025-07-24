import {Product, ElectronicProduct} from "./Models/Model.js"
import { Article } from "./Models/Article.js"
import {getArticleList,getArticle,createArticle,patchArticle} from "./API/ArticleService.js"
import {getProductList,getProduct, createProduct, patchProduct} from "./API/ProductService.js"

async function run() {
  const productList = await getProductList() || [];
  const products =  productList.list.map(p => {

      const isElectronic = p.tags && p.tags.includes("전자기기");

      return isElectronic
        ? new ElectronicProduct(
            p.name,
            p.price,
            p.tags,
            p.images,
            p.favoriteCount,
            p.manufacturer
          )
        : new Product(
            p.name,
            p.price,
            p.tags,
            p.images,
            p.favoriteCount
          );
    });
    
    products.forEach((p, i) => console.log(`Product #${i + 1}`, p));
 
    console.log(products[0].tags)
  }
  
run();
