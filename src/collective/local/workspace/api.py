from collective.local.workspace.interfaces import IWorkspace

def get_workspace(obj):
    for item in reversed(obj.aq_chain):
        if IWorkspace.providedBy(item):
            return item
    else:
        return None