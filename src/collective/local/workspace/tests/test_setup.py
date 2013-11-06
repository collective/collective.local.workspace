import unittest2 as unittest

from Products.CMFCore.utils import getToolByName

from collective.local.workspace.testing import INTEGRATION
from plone.stringinterp.interfaces import IStringInterpolator
from plone.app.testing.helpers import login
from plone.app.testing.interfaces import SITE_OWNER_NAME


class FakeResponse(object):

    def redirect(self, url):
        self.redirection = url


class TestExample(unittest.TestCase):

    layer = INTEGRATION

    def setUp(self):
        self.app = self.layer['app']
        self.portal = self.layer['portal']
        self.qi_tool = getToolByName(self.portal, 'portal_quickinstaller')

    def test_product_is_installed(self):
        """ Validate that our products GS profile has been run and the product
            installed
        """
        pid = 'collective.local.workspace'
        installed = [p['id'] for p in self.qi_tool.listInstalledProducts()]
        self.assertTrue(pid in installed,
                        'package appears not to have been installed')

    def test_workspace(self):
        login(self.app, SITE_OWNER_NAME)
        #self.portal.REQUEST.RESPONSE = FakeResponse()
        self.portal.invokeFactory('workspace', 'workspace', title='My workspace')
        workspace = self.portal.workspace

        # test copy paste
        cb = self.portal.manage_copyObjects(['workspace'])
        self.portal.manage_pasteObjects(cb)

        # test string interp
        # self.portal.workspace.invokeFactory('Document', 'document', title='My document')
        # doc = workspace.document
        # title_value = IStringInterpolator(doc)("${workspace_title}")
        # self.assertEqual(title_value, 'My workspace')
