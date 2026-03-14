# Generic Deep Clone LWC for Salesforce

Turbocharge your Salesforce Org with the **Generic Deep Clone LWC**! This powerful, modular, and highly customizable Lightning Web Component allows you to seamlessly clone any Standard or Custom Object—along with its related child records—in a single, unified action.

## 🚀 Key Features

*   **Deep Cloning Magic:** Clone parent records and their related child records simultaneously. Say goodbye to manual data entry for complex object hierarchies!
*   **100% Object Agnostic:** Built to be generic. Whether it's an Opportunity with Products, a Quote with Line Items, or your own Custom Objects, this component handles it all.
*   **Field Set Driven Configuration:** No hard-coded fields here! Administrators have full control over exactly which fields are cloned simply by configuring standard Salesforce Field Sets.
*   **Granular Field Control:** Need to exclude specific fields (like `TotalPrice`) or ensure others are included entirely? The robust Apex controller logic allows you to dynamically define `includeFields` and `excludeFields` during the cloning process.
*   **Modular Architecture:** The solution is broken down into reusable frontend components (`genericCloneObject` and `genericCloneChildObject`), making it incredibly easy to snap into any existing business process, flow, or UI.
*   **Out-of-the-Box Opportunity Clone:** Includes a fully functional `cloneOpportunityButton` LWC as a reference implementation. You can deploy and start cloning Opportunities and Opportunity Products on day one!
*   **Enterprise Ready:** Complete with a Test Factory and Unit Tests ensuring reliable deployments, bulkified operations, and robust code coverage.

## 🛠️ How it Works

The project utilizes a combination of Lightning Web Components for a snappy frontend UI and robust Apex controllers for backend processing. 

1. **Parent Component:** Uses `genericCloneObject` to display a dynamic form based on your configured Field Set for the parent object.
2. **Child Component:** Uses `genericCloneChildObject` to display an editable data table of related child records, also driven by a Field Set.
3. **Save Action:** A single click cascades the save operation, creating the new parent record first, then intelligently reparenting and inserting the cloned child records.

## 📦 What's Included?

- **LWC Components:** `genericCloneObject`, `genericCloneChildObject`, `cloneOpportunityButton`, `utility`
- **Apex Classes:** `GenericCloneObjectController`, `GenericCloneChildObjectController`, `UtilityClass`, `TestFactory`

Start deep cloning with ease today!
