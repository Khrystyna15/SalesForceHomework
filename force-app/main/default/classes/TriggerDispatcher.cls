public class TriggerDispatcher 
{
    /*
        Call this method from your trigger, passing in an instance of a trigger handler which implements ITriggerHandler.
        This method will fire the appropriate methods on the handler depending on the trigger context.
    */
    public static void run(ITriggerHandler handler)
    {
        // Check to see if the trigger has been disabled. If it has, return
        // if (handler.IsDisabled())
        //     return;
             
        // Detect the current trigger context and fire the relevant methods on the trigger handler:
 
        // Before trigger logic
        if (Trigger.IsBefore )
        {
            if (Trigger.IsInsert)
                handler.beforeInsert(trigger.new);
             if (Trigger.IsUpdate)
                handler.beforeUpdate(trigger.newMap, trigger.oldMap);
             if (Trigger.IsDelete)
                handler.beforeDelete(trigger.oldMap);
        }
        // After trigger logic
        if (Trigger.IsAfter)
        {
            if (Trigger.IsInsert)
                handler.afterInsert(Trigger.newMap);
            if (Trigger.IsUpdate)
                handler.afterUpdate(trigger.newMap, trigger.oldMap);
             if (trigger.IsDelete)
                handler.afterDelete(trigger.oldMap);
            if (trigger.isUndelete)
                handler.afterUndelete(trigger.oldMap);
        }
    }
}