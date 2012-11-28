from plone.app.testing import PloneWithPackageLayer
from plone.app.testing import IntegrationTesting
from plone.app.testing import FunctionalTesting

import collective.local.workspace


COLLECTIVE_LOCAL_WORKSPACE = PloneWithPackageLayer(
    zcml_package=collective.local.workspace,
    zcml_filename='testing.zcml',
    gs_profile_id='collective.local.workspace:testing',
    name="COLLECTIVE_LOCAL_WORKSPACE")

COLLECTIVE_LOCAL_WORKSPACE_INTEGRATION = IntegrationTesting(
    bases=(COLLECTIVE_LOCAL_WORKSPACE, ),
    name="COLLECTIVE_LOCAL_WORKSPACE_INTEGRATION")

COLLECTIVE_LOCAL_WORKSPACE_FUNCTIONAL = FunctionalTesting(
    bases=(COLLECTIVE_LOCAL_WORKSPACE, ),
    name="COLLECTIVE_LOCAL_WORKSPACE_FUNCTIONAL")
