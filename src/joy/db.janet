(import db)


(defn db/save [arg]
  (if (arg :db/errors)
    arg
    (let [updated-at ((db/put-updated-at (arg :db/table) @{}) :updated-at)
          created-at updated-at

          set-attrs (-> (table ;(kvs arg))
                        (put :updated-at updated-at)
                        (put :db/errors nil)
                        (put :db/table nil))

          insert-attrs (-> (table ;(kvs arg))
                           (put :created-at created-at)
                           (put :updated-at updated-at)
                           (put :db/errors nil))]

        (let [row (db/insert insert-attrs
                             :on-conflict :id
                             :do :update
                             :set set-attrs)]
          (if-not row
            (merge arg {:db/errors "Could not save to the database."})
            (merge row {:db/saved true}))))))


(defn saved? [arg]
  (true? (get arg :db/saved)))


(defn errors [arg]
  (get arg :db/errors))
