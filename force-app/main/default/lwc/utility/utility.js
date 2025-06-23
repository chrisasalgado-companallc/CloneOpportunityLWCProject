import { ShowToastEvent } from "lightning/platformShowToastEvent";

/**
 * @description Dispatch a toast notification.
 * @param component Component where the toast will be displayed.
 * @param title Title of the toast.
 * @param message Message content of the toast.
 * @param variant Variant of the toast ['success', 'error', 'warning', 'info'].
 * @param mode Mode of the toast ['dismissible', 'pester', 'sticky'].
 * @param messageDate List of Objects to associate to link references in message [{ url: recordUrl, label: MessageLabel }]
 */
export const showToast = (component, title, message, variant, mode = 'dismissible', messageData) => {
    component.dispatchEvent(
        new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode,
            ...(messageData && { messageData: messageData })
        })
    );
};