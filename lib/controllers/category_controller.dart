import 'package:muzn/models/circle_category_model.dart';
import 'package:muzn/repository/category_repository.dart';

class CirclesCategoryController {
  final CirclesCategoryRepository categoryRepository = CirclesCategoryRepository();

  // Fetch all CirclesCategories
  Future<List<CirclesCategory>> getAllCategories() async {
    try {
      return await categoryRepository.fetchCategories();
    } catch (e) {
      throw Exception("Failed to fetch categories: $e");
    }
  }

  // Fetch a single category by ID
  Future<CirclesCategory?> getCategoryById(int id) async {
    try {
      return await categoryRepository.fetchCategoryById(id);
    } catch (e) {
      throw Exception("Failed to fetch category with ID $id: $e");
    }
  }

  // Create a new category
  Future<bool> createCategory(CirclesCategory category) async {
    try {
      return await categoryRepository.addCategory(category);
    } catch (e) {
      throw Exception("Failed to create category: $e");
    }
  }

  // Update an existing category
  Future<bool> updateCategory(int id, CirclesCategory category) async {
    try {
      return await categoryRepository.updateCategory(id, category);
    } catch (e) {
      throw Exception("Failed to update category with ID $id: $e");
    }
  }

  // Delete a category
  Future<bool> deleteCategory(int id) async {
    try {
      return await categoryRepository.deleteCategory(id);
    } catch (e) {
      throw Exception("Failed to delete category with ID $id: $e");
    }
  }
}
