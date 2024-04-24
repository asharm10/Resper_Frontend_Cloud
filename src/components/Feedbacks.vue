<template>
    <v-sheet min-height="70vh" rounded="lg">
        <center>
            <h2 class="pt-8">Feedbacks</h2>

        </center>
        <div class="pa-5">
            <p>Average Rating: <b>{{ rating }}</b>
                <v-btn small color="error" class="ml-10" @click="getRating()">View all Ratings</v-btn>
            </p>

        </div>
        <v-dialog v-model="dialog" width="500">
            <v-card>
                <v-card-title class="text-h5 grey lighten-2">
                    All Ratings
                </v-card-title>

                <v-card-text class="pt-5">
                    <v-data-table :headers="headers" :items="dialogRatings" :items-per-page="5">
                        <template v-slot:item="row">
                            <tr>
                                <td>{{ row.item.date.split(' ').slice(0, 5).join(' ') }}</td>
                                <td>{{ row.item.rating }}</td>
                                <td>
                                    <v-icon small @click="deleteRating(row.item._id)">
                                        mdi-delete
                                    </v-icon>
                                </td>
                            </tr>

                        </template>
                    </v-data-table>
                </v-card-text>

                <v-divider></v-divider>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" text @click="dialog = false">
                        Close
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-dialog v-model="dialog2" width="500">
            <v-card>
                <v-card-title class="text-h5 grey lighten-2">
                    Feedback
                </v-card-title>
                <div class="pa-5">
                    {{ dialog2Feedback }}

                    <p class="text-caption">
                        {{ dialog2Date }}
                    </p>
                </div>

                <v-card-text class="pt-5">

                </v-card-text>

                <v-divider></v-divider>

                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="primary" text @click="dialog2 = false">
                        Close
                    </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>

        <v-list two-line>
            <v-list-item-group v-model="selected">
                <template v-for="(item, index) in feedbacks">
                    <v-list-item :key="item.feedback">
                        <template>
                            <v-list-item-content @click="showFeedbackDialog(item.feedback, item.date)" v-bind="attrs" v-on="on">
                                <v-list-item-title v-text="item.feedback"></v-list-item-title>
                                <v-list-item-subtitle class="text--primary"
                                    v-text="item.date.split(' ').slice(0, 5).join(' ')">
                                </v-list-item-subtitle>
                            </v-list-item-content>



                            <!-- <v-list-item-content>
                          <v-list-item-title v-text="item.fullname"></v-list-item-title>
                          <v-list-item-subtitle class="text--primary" v-text="item.username"></v-list-item-subtitle>
                        </v-list-item-content> -->

                            <v-list-item-action>

                                <v-icon color="grey lighten-1" @click="remove(item._id)">
                                    mdi-delete-outline
                                </v-icon>

                            </v-list-item-action>
                        </template>
                    </v-list-item>

                    <v-divider v-if="index < feedbacks.length - 1" :key="index"></v-divider>
                </template>
            </v-list-item-group>
        </v-list>
    </v-sheet>
</template>
<script>
export default {
    name: "FeedbackList",
    data() {
        return {
            feedbacks: [],
            dialogRatings: [],
            rating: 0,
            dialog: false,
            dialog2: false,
            dialog2Feedback: '',
            dialog2Date: '',
            headers: [
                {
                    text: 'Date',
                    value: 'date',
                },
                {
                    text: 'Rating',
                    value: 'rating'
                },
                {
                    text: 'Actions', value: 'actions', sortable: false
                }
            ]
        };
    }, async created() {
        this.getFeedbacks();
        this.calculateRating();
    },
    methods: {
        showFeedbackDialog(feedback, date) {
            this.dialog2Feedback = feedback;
            this.dialog2Date = date;
            this.dialog2 = true;
        },
        async getRating() {
            await this.getFeedbacks();
            await this.calculateRating();
            this.dialog = true;
        },
        async deleteRating(id) {
            const res = await fetch(
                process.env.VUE_APP_BACKEND_URL + "admin/ratings",
                {
                    method: "DELETE",
                    credentials: 'include',

                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        id
                    })
                }
            ,);
            const data = await res.json();
            if (data.status === 200) {
                await this.calculateRating();
            } else {
                alert("Could not delete the rating!")
            }
        }
        ,
        async getFeedbacks() {
            const res = await fetch(
                process.env.VUE_APP_BACKEND_URL + "admin/feedbacks",
                {
                    method: "GET",
                    credentials: 'include',
                }
            ,);
            let data = await res.json();
            // data=data.success;
            console.log(data);
            this.feedbacks = data.success.reverse();
            //this.data=data.success;
        },

        async calculateRating() {
            const res = await fetch(
                process.env.VUE_APP_BACKEND_URL + "admin/ratings",
                {
                    method: "GET",
                    credentials: 'include',

                    headers: {
                        "Content-Type": "application/json"
                    },
                }
            ,);
            const data = await res.json();
            if (data.success.length === 0) {
                this.rating = 0;
                this.dialogRatings = []
                return;
            }
            let sum = 0;
            data.success.forEach(element => {
                sum += element.rating;
            });
            this.dialogRatings = data.success;
            this.rating = (sum / data.success.length).toPrecision(2);
            console.log(sum);
        },

        async remove(id) {

            const res = await fetch(
                process.env.VUE_APP_BACKEND_URL + "admin/feedbacks",
                {
                    method: "DELETE",
                    credentials: 'include',

                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({
                        id
                    })
                }
            ,);
            const data = await res.json();
            if (data.status === 200) {
                await this.getFeedbacks();
            } else {
                alert("Could not delete the feedback!")
            }
        },
    }
}
</script>