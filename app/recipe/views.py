"""
Views for the recipe APIs
"""
from rest_framework import viewsets
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated

from core.models import Recipe
from recipe import serializers


class RecipeViewSet(viewsets.ModelViewSet):
  """View for manage recipe APIs"""
  # define cómo se serializa Recipe
  serializer_class = serializers.RecipeDetailSerializer
  # base (luego se filtra en get_queryset)
  queryset = Recipe.objects.all()
  authentication_classes = [TokenAuthentication]     # requiere token
  permission_classes = [IsAuthenticated]             # debe estar autenticado

  def get_queryset(self):
    """Retrieve recipes for authenticated user."""
    # overwrite de generic method
    # filtra por el usuario del request y ordena desc por id
    return self.queryset.filter(user=self.request.user).order_by('-id')

  def get_serializer_class(self):
    """Return the serializer class for request."""
    if self.action == 'list':
      return serializers.RecipeSerializer

    return self.serializer_class

  def perform_create(self, serializer):
      """Create a new recipe."""
      serializer.save(user=self.request.user)
