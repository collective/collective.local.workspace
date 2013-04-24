from zope.interface.declarations import implements
from plone.dexterity.content import Container
from collective.local.workspace.interfaces import IWorkspace

class Workspace(Container):

    implements(IWorkspace)
