package prm.prmbackend.entity.enums;

/**
 * Billing cycle of a subscription bundle. Determines how many days of premium
 * access a successful payment grants.
 */
public enum BillingCycle {
    MONTHLY(30),
    QUARTERLY(90),
    YEARLY(365);

    private final int durationDays;

    BillingCycle(int durationDays) {
        this.durationDays = durationDays;
    }

    public int getDurationDays() {
        return durationDays;
    }
}
